//
//  ArtworkRepositoryTests.swift
//  ios-itunes-search-appTests
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import XCTest
import Result
import APIKit
@testable import ios_itunes_search_app

class ArtworkRepositoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ArtworkDao.deleteAll()
    }
    
    override func tearDown() {
        ArtworkDao.deleteAll()
        super.tearDown()
    }
    
    /// 先にキャッシュを保存し、次にキャッシュに紐付いたURLを渡して、
    /// キャッシュ画像データを取り出し、新たに画像をダウンロードしようとしていないことを確認
    func testFetchFromCache() {
        let url = "example.com"
        // 一旦キャッシュに保存させる
        var dto = ArtworkDto()
        dto.url = url
        dto =  ArtworkDao.add(dto)
        //キャッシュを取り出す
        let completion: MockImageDownload.Completion = { downloadCompltion in
            downloadCompltion(.success(UIImage(named: "snow.jpg")!))
        }
        let mock = MockImageDownload(completion)
        let artworkRepo = ArtworkRepository(dependency: mock)
        artworkRepo.artwork(in: url) { result in
            switch result {
            case .success(let artwork):
                if mock.count > 0 {
                    XCTFail("ダウンロードが走っている")
                    return
                }
                self.varify(lhs: artwork,
                            rhs: Artwork(from: dto))
            case .failure(let error):
                print(error)
                XCTFail("ダウンロードエラーが発生")
            }
        }
    }
    /// 実際に画像をダウンロードしてくること・キャッシュに保存していることを確認
    func testFetchDownload() {
        let url = "http://is1.mzstatic.com/image/thumb/Music2/v4/a2/66/32/a2663205-663c-8301-eec7-57937c2d0878/source/100x100bb.jpg"
        let artworkRepo = ArtworkRepository(dependency: ArtworkClient(dependency: NetworkUtil()))
        artworkRepo.artwork(in: url) { [weak self] result in
            switch result {
            case .success(let artwork):
                //キャッシュからアートワークを検索
                let predicate = NSPredicate(format: "url LIKE '\(url)'")
                let findResult = ArtworkDao.find(by: predicate)
                if findResult.isEmpty {
                    XCTFail("キャッシュ出来ていない")
                }
                assert(findResult.count == 1)
                self?.varify(lhs: artwork,
                       rhs: Artwork(from: findResult[0]))
            case .failure(let error):
                XCTestCase.logPrint(strings: error.localizedDescription)
                XCTFail("エラー発生")
            }
        }
    }
}
extension XCTestCase {
    func varify(lhs: Artwork, rhs: Artwork) {
        XCTAssertEqual(lhs.id, rhs.id)
        XCTAssertEqual(lhs.url, rhs.url)
        compareJpegImage(lhs: lhs.image, rhs: rhs.image)
    }
}
private class MockImageDownload: ImageDownloadable {
    typealias Completion = ((Result<UIImage, SessionTaskError>) -> Void) -> Void
    /// ダウンロード処理が呼ばれたらカウントが一つ増える
    var count: Int = 0
    let completion: Completion?
    
    init(_ completion: Completion?) {
        self.completion = completion
    }
    func downloadImage(url: String,
                       completion: @escaping (Result<UIImage, SessionTaskError>) -> Void) {
        count += 1
        self.completion?(completion)
    }
}
