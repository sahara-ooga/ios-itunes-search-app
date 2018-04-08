//
//  iTunesSearchRequest.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import Foundation
import APIKit

protocol iTunesSearchRequest: Request {
    
}

extension iTunesSearchRequest {
    var baseURL: URL {
        return URL(string: "https://itunes.apple.com")!
    }
}

extension iTunesSearchRequest where Response: Decodable {
    var dataParser: DataParser {
        return DecodableDataParser()
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
//    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
//        print(object)
//        print(urlResponse)
//        return object
//    }
}
