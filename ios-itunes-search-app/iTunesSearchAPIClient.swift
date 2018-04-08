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

struct iTunesSearchAPIClient {
    static func searchTracks(query: String,
                             limit: Int = 50,
                             completion: @escaping (Result<iTunesSearchResponse, APIKit.SessionTaskError>) -> Void) {
        //接続可能性をチェックし、通信不可能ならエラーを投げる
        let connectivity =  NetworkUtil.connectivity()
        if case .none = connectivity {
           completion(.failure(SessionTaskError.connectionError(ConnectionError.noConnection)))
        }
        
        let request = iTunesSearchAPI.SearchTracks(query: query, limit: limit)
        Session.send(request, handler: completion)
    }
}
