//
//  ArtworkDtoTests.swift
//  ios-itunes-search-appTests
//
//  Created by yogasawara@stv on 2018/04/14.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import XCTest
@testable import ios_itunes_search_app

class ArtworkDtoTests: XCTestCase {
    let item = ArtworkDto()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testArtworkDtoDefault() {
        XCTAssertEqual(item.id, 0)
        XCTAssertEqual(item.url, "")
        XCTAssertNil(item.image)
    }
}
