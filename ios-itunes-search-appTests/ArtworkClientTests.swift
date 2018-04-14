//
//  ArtworkClientTests.swift
//  ios-itunes-search-appTests
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import XCTest
@testable import ios_itunes_search_app

class ArtworkClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /// 正常系
    func testDownloadImage() {
        let expectation = XCTestExpectation(description: "Download artwork")
        let artworkClient = ArtworkClient(dependency: (NetworkUtil()))
        let imageURL = "http://is1.mzstatic.com/image/thumb/Music2/v4/a2/66/32/a2663205-663c-8301-eec7-57937c2d0878/source/100x100bb.jpg"
        artworkClient.downloadImage(url: imageURL){ result in
            guard case .success(_) = result else {
                XCTFail("fail to download image")
                return
            }
            expectation.fulfill()
        }
        wait(for:[expectation],timeout:30.0)
    }
    /// 通信不可能時の挙動を試す
    func testWhenNoConnectivity() {
        let imageURL = "http://is1.mzstatic.com/image/thumb/Music2/v4/a2/66/32/a2663205-663c-8301-eec7-57937c2d0878/source/100x100bb.jpg"
        /// 通信不可能時の状況を再現するモック
        struct MockNetworkUtil: ConnnectibityCheckable {
            func connectivity() -> Connnectibity {
                return .none
            }
        }
        let expectation = XCTestExpectation(description: "Search iTunes API")
        let artworkClient = ArtworkClient(dependency: (MockNetworkUtil()))
        artworkClient.downloadImage(url: imageURL){ result in
            switch result {
            case .failure(_):
                expectation.fulfill()
            case .success(_):
                XCTFail("通信してしまったので失敗")
            }
        }
        wait(for:[expectation],timeout:30.0)
    }
}
