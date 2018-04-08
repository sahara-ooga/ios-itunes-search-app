//
//  iTunesSearchAPITests.swift
//  ios-itunes-search-appTests
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import XCTest
@testable import ios_itunes_search_app
import APIKit

class iTunesSearchAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let expectation = XCTestExpectation(description: "Search iTunes API")
        
        Session.send(iTunesSearchAPI.SearchTracks(query: "jack+johnson", limit: 3)) { result in
            switch result {
            case .success(let response):
                print(response)
                expectation.fulfill()
            case .failure(let error):
                print("error: \(error)")
                XCTFail("fail to search.")
            }
        }
        wait(for:[expectation],timeout:30.0)
    }
    
}
