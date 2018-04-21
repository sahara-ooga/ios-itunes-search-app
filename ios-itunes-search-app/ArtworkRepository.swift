//
//  File.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import APIKit
import Result
import UIKit

protocol ArtworkRepositoryProtocol {
    func artwork(in url: String,
                 completion: @escaping (Result<Artwork, APIKit.SessionTaskError>) -> Void)
}
final class ArtworkRepository: ArtworkRepositoryProtocol, DependencyInjectionable {
    let realmQueue = DispatchQueue.main
    typealias Dependency = (ImageDownloadable)
    var dependency: (ImageDownloadable)
    
    required init(dependency: (ImageDownloadable)) {
        self.dependency = dependency
    }
    func artwork(in url: String,
                 completion: @escaping (Result<Artwork, SessionTaskError>) -> Void) {
        search(from: url) { [weak self] realmSearchResult in
            switch realmSearchResult {
            case .some(let artworkDto):
                completion(.success(Artwork(from: artworkDto)))
            case .none:
                //キャッシュがなければ、URLから取得する
                //イメージを取得したら、Artwork型に変換し、キャッシュに保存してから完了ハンドラに渡す
                let imageDownloader = self?.dependency
                imageDownloader?.downloadImage(url: url) { result in
                    switch result {
                    case .success(let image):
                        let dto = ArtworkDto()
                        dto.id = 1
                        dto.url = url
                        dto.image = image
                        
                        self?.execute(realmHandler: {ArtworkDao.add(dto)}) { insertedDto in
                            let artwork = Artwork(from: insertedDto)
                            completion(.success(artwork))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

// MARK: - Realm Handling
extension ArtworkRepository {
    enum SearchResult {
        case some(ArtworkDto)
        case none
    }
    func search(from url: String,
                completion: @escaping (SearchResult) -> Void) {
        let predicate = NSPredicate(format: "url LIKE '\(url)'")
        execute(realmHandler: { ArtworkDao.find(by: predicate) }) { (result: [ArtworkDto]) in
                    if result.isEmpty {
                        completion(.none)
                    } else {
                        completion(.some(result[0]))
                    }
        }
    }
    /// Realmのハンドリングでスレッドエラーが起こらないようにするための措置
    ///
    /// - Parameters:
    ///   - realmHandler: Realmを扱う処理
    ///   - completion: Realmのトランザクション後に行う処理
    func execute<T>(realmHandler: @escaping () -> T,
                    completion: @escaping (T) -> Void) {
        realmQueue.async {
            let result = realmHandler()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
