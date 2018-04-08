//
//  iTunesSearchAPI.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//
import APIKit

final class iTunesSearchAPI {
    private init() {}
    
    struct SearchTracks: iTunesSearchRequest {
        typealias Response = iTunesSearchResponse
        
        let method: HTTPMethod = .get
        let path: String = "/search"
        var parameters: Any? {
            return ["term": query, "entity": "song", "limit": limit]
        }
        //検索ワード
        let query: String
        //取得件数の上限
        let limit: Int
    }
}
