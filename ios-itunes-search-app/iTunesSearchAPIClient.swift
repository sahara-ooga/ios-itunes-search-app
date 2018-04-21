//
//  iTunesSearchAPIClient.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import Foundation
import APIKit
import Result

protocol iTunesSearchAPIClientProtocol {
    func searchTracks(query: String,
                      limit: Int,
                      completion: @escaping (Result<iTunesSearchResponse, APIKit.SessionTaskError>) -> Void)
}
struct iTunesSearchAPIClient {
    // MARK: DI
    typealias Dependency = (
        ConnnectibityCheckable
    )
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}
extension iTunesSearchAPIClient: iTunesSearchAPIClientProtocol {
    func searchTracks(query: String,
                      limit: Int = 50,
                      completion: @escaping (Result<iTunesSearchResponse, APIKit.SessionTaskError>) -> Void) {
        let connectivityChecker = self.dependency
        //接続可能性をチェックし、通信不可能ならエラーを投げて終了
        let connectivity =  connectivityChecker.connectivity()
        if case .none = connectivity {
           completion(.failure(SessionTaskError.connectionError(ConnectionError.noConnection)))
            return
        }
        
        let request = iTunesSearchAPI.SearchTracks(query: query, limit: limit)
        Session.send(request, handler: completion)
    }
}
