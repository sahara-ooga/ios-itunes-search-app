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
    func artwork(in url:String,
                 completion: @escaping (Result<Artwork, APIKit.SessionTaskError>) -> Void) -> Void
}
class ArtworkRepository: ArtworkRepositoryProtocol,DependencyInjectionable {

    typealias Dependency = (ImageDownloadable)
    var dependency: (ImageDownloadable)
    
    required init(dependency: (ImageDownloadable)) {
        self.dependency = dependency
    }
    func artwork(in url: String,
                 completion: @escaping (Result<Artwork, SessionTaskError>) -> Void) -> Void {
        //キャッシュからアートワークを検索し、画像があれば完了ハンドラに渡す
        let predicate = NSPredicate(format: "url LIKE '\(url)'")
        //TODO: Daoのプロトコル化
        let result = ArtworkDao.find(by: predicate)
        if !(result.isEmpty) {
            let artwork = Artwork(from: result[0])
            completion(.success(artwork))
            return
        }
        //キャッシュがなければ、URLから取得する
        //イメージを取得したら、Artwork型に変換し、キャッシュに保存してから完了ハンドラに渡す
        let imageDownloader = self.dependency
        imageDownloader.downloadImage(url: url) {
            result in
            switch result {
            case .success(let image):
                let dto = ArtworkDto()
                dto.id = 1
                dto.url = url
                dto.image = image
                //キャッシュ保存を経てidが変化していることに注意
                let insertedDto: ArtworkDto = ArtworkDao.add(dto)
                let artwork = Artwork(from: insertedDto)
                completion(.success(artwork))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
