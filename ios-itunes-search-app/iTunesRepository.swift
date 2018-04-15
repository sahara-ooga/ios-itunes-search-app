//
//  iTunesRepository.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//
import APIKit
import Result

protocol iTunesRepositoryProtocol {
    func search(query: String,
                limit: Int,
                completion: @escaping (Result<iTunesSearchResponse, APIKit.SessionTaskError>) -> Void)
}

final class iTunesRepository {
    typealias Dependency = (iTunesSearchAPIClientProtocol)
    var dependency: (iTunesSearchAPIClientProtocol)
    
    required init(dependency: (iTunesSearchAPIClientProtocol)) {
        self.dependency = dependency
    }
}
extension iTunesRepository: iTunesRepositoryProtocol {
    func search(query: String,
                limit: Int = 50,
                completion: @escaping (Result<iTunesSearchResponse, APIKit.SessionTaskError>) -> Void) {
        let apiClient = self.dependency
        apiClient.searchTracks(query: query,
                               limit: limit) { result in
                                completion(result)
        }
    }
}
