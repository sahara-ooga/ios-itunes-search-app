//
//  ArtworkClient.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import UIKit
import Result
import APIKit

protocol ImageDownloadable {
    func downloadImage(url: String,
                       completion: @escaping (Result<UIImage, APIKit.SessionTaskError>) -> Void)
}
struct ArtworkClient: DependencyInjectionable, ImageDownloadable {
    // MARK: DI
    typealias Dependency = (
        ConnnectibityCheckable
    )
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func downloadImage(url: String,
                      completion: @escaping (Result<UIImage, APIKit.SessionTaskError>) -> Void) {
        let connectivityChecker = self.dependency
        //接続可能性をチェックし、通信不可能ならエラーを投げて終了
        let connectivity =  connectivityChecker.connectivity()
        if case .none = connectivity {
            completion(.failure(SessionTaskError.connectionError(ConnectionError.noConnection)))
            return
        }
        guard let imageURL = URL(string: url) else {
            completion(.failure(SessionTaskError.requestError(RequestError.stringToUrl)))
            return
        }
        let session = URLSession(configuration: .default)
        let downloadTask = session.dataTask(with: imageURL) { (data, _, error) in
            if let e = error {
                //TODO: エラーの分類
                print(e)
            } else {
                guard let imageData = data else {
                    completion(.failure(SessionTaskError.responseError(ArtworkResponseError.dataIsNil)))
                    return
                }
                guard let image = UIImage(data: imageData) else {
                    completion(.failure(SessionTaskError.responseError(ArtworkResponseError.imageTranslation)))
                    return
                }
                completion(.success(image))
            }
        }
        downloadTask.resume()
    }
}
