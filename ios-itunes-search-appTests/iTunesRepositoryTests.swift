//
//  iTunesRepositoryTests.swift
//  ios-itunes-search-appTests
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import XCTest
import Result
import APIKit
@testable import ios_itunes_search_app

class iTunesRepositoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /// JSONから読み込んだレスポンスが返ってくるか確認
    func testSearch() {
        guard let response = iTunesRepositoryTests.loadItunesSearchResponse() else {
            XCTFail("JSONからの読み込みに失敗"); return }
        let completion: MockItunesAPIClient.Completion = { completion in
            completion(.success(response))
        }
        let mock = MockItunesAPIClient(response: response,
                                       completion: completion)
        let repository = iTunesRepository(dependency: mock)
        repository.search(query: "query") { [weak self] result in
            guard case .success(let returnedResponse) = result else {
                XCTFail("想定外のエラー")
                return
            }
            self?.varify(lhs: response,
                         rhs: returnedResponse)
        }
    }
}
fileprivate struct MockItunesAPIClient {
    typealias Completion = (((Result<iTunesSearchResponse, SessionTaskError>) -> Void) -> Void)
    let response: iTunesSearchResponse
    let completion: Completion?
}
extension MockItunesAPIClient: iTunesSearchAPIClientProtocol {
    func searchTracks(query: String,
                      limit: Int,
                      completion: @escaping (Result<iTunesSearchResponse, SessionTaskError>) -> Void) {
        XCTestCase.logPrint(strings: "呼ばれたお")
        self.completion?(completion)
    }
}
extension XCTestCase {
    static func loadItunesSearchResponse() -> iTunesSearchResponse? {
        let searchResultData = self.jsonDataFromFile("iTunesResponse")!
        return try? JSONDecoder().decode(iTunesSearchResponse.self,
                                         from: searchResultData)
    }
    func varify(lhs: iTunesSearchResponse,
                rhs: iTunesSearchResponse) {
        XCTAssertEqual(lhs.resultCount, rhs.resultCount)
        let lTrack = lhs.results[0]
        let rTrack = rhs.results[0]
        XCTAssertEqual(lTrack.trackName, rTrack.trackName)
        XCTAssertEqual(lTrack.artistName, rTrack.artistName)
        XCTAssertEqual(lTrack.artworkUrl100, rTrack.artworkUrl100)
    }
}
