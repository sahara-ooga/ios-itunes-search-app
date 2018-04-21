//
//  iTunesSearchAPIClientTests.swift
//  ios-itunes-search-appTests
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import XCTest
@testable import ios_itunes_search_app
import Result

class iTunesSearchAPIClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /// 正常系
    func testSearchTracks() {
        let expectation = XCTestExpectation(description: "Search iTunes API")
        let expectResultCount = 3
        let searchAPIClient = iTunesSearchAPIClient(dependency: (NetworkUtil()))
        searchAPIClient.searchTracks(query: "Neil+Young",
                                     limit: expectResultCount) {result in
                                                    guard case .success(let searchResponse) = result else {
                                                        XCTFail("fail to search iTunes API")
                                                        return
                                                    }
                                                    XCTAssertEqual(searchResponse.results.count,
                                                                   expectResultCount)
                                                    expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30.0)
    }
    /// iTunesSearchAPIClientの、通信不可能時の挙動を試す
    func testSearchTracksWhenNoConnectivity() {
        /// 通信不可能時の状況を再現するモック
        struct MockNetworkUtil: ConnnectibityCheckable {
            func connectivity() -> Connnectibity {
                return .none
            }
        }
        let expectation = XCTestExpectation(description: "Search iTunes API")
        let expectResultCount = 3
        let searchAPIClient = iTunesSearchAPIClient(dependency: (MockNetworkUtil()))
        searchAPIClient.searchTracks(query: "Neil+Young",
                                       limit: expectResultCount) {result in
                                            switch result {
                                            case .failure:
                                                expectation.fulfill()
                                            case .success:
                                                XCTFail("通信してしまったので失敗")
                                            }
        }
        wait(for: [expectation], timeout: 30.0)
    }
}
