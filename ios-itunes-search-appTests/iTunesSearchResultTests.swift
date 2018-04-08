//
//  ios_itunes_search_appTests.swift
//  ios-itunes-search-appTests
//
//  Created by yogasawara@stv on 2018/03/23.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import XCTest
@testable import ios_itunes_search_app

class iTunesSearchResultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecodeResponseJSON() {
        let expectedSearchResultsCount = 3
        let searchResultData = iTunesSearchResultTests.jsonDataFromFile("iTunesResponse")!
        guard let searchResult = try? JSONDecoder().decode(iTunesSearchResponse.self,
                                                           from: searchResultData) else {
            XCTFail("decoded result is nil")
            return
        }
        XCTAssertEqual(searchResult.results.count, expectedSearchResultsCount)
    }
    
}
