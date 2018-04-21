//
//  ArtworkDaoTests.swift
//  ios-itunes-search-appTests
//
//  Created by yogasawara@stv on 2018/04/14.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import XCTest
@testable import ios_itunes_search_app

class ArtworkDaoTests: XCTestCase {
    override func setUp() {
        super.setUp()
        ArtworkDao.deleteAll()
    }
    override func tearDown() {
        ArtworkDao.deleteAll()
        super.tearDown()
    }
    func testAddItem() {
        let expectedId = 1
        let expectedUrl = "https://example.com"
        let expectedImage = UIImage(named: "snow.jpg")
        //Setup
        let object = ArtworkDto()
        object.id = expectedId
        object.url = expectedUrl
        object.image = expectedImage
        ArtworkDao.add(model: object)
        //Verify
        verifyFirstItem(expectedId: expectedId,
                        expectedUrl: expectedUrl,
                        expectedImage: expectedImage)
    }
    func testFindItemById() {
        var expected = (id: 1,
                        url: "expected url",
                        image: UIImage(named: "spareribs.jpg"))
        //Setup
        let object = ArtworkDto()
        object.id = expected.id
        object.url = expected.url
        object.image = expected.image
        
        //Exercise
        expected.id = ArtworkDao.add(model: object)
        let result = ArtworkDao.find(by: expected.id)
        
        //Verify
        XCTAssertEqual(result?.url, expected.url)
        compareJpegImage(lhs: result?.image, rhs: expected.image)
    }
    func testUpdateItem() {
        var expected = (id: 1,
                        url: "updated URL",
                        image: UIImage(named: "spareribs.jpg"))
        //Setup
        let object = ArtworkDto()
        object.id = expected.id
        object.url = "URL"
        object.image = UIImage(named: "snow.jpg")
        
        //Execute
        let addedId = ArtworkDao.add(model: object)
        expected.id = addedId
        
        //load added item
        guard let loaded = ArtworkDao.find(by: addedId) else {
            XCTFail("Fail to load")
            return
        }
        //update added item
        ArtworkDao.update(model: loaded) {
            //******注意*******
            //Dao.findメソッドで取得したオブジェクトは、
            //writeの引数のクロージャ内で更新しないとエラーが発生した
            loaded.url = expected.url
            loaded.image = expected.image
        }
        //Verify
        verifyFirstItem(expectedId: expected.id,
                        expectedUrl: expected.url,
                        expectedImage: expected.image)
    }
    func testDeleteItem() {
        //Setup
        let object = ArtworkDto()
        object.id = 1
        object.url = "タイトル"
        object.image = UIImage(named: "snow.jpg")
        
        //Execute
        let addedId = ArtworkDao.add(model: object)
        ArtworkDao.delete(id: addedId)
        
        //Verify
        verifyCount(count: 0)
    }
    func testFindAllItem() {
        
        //Setup
        let tasks = [ArtworkDto(), ArtworkDto(), ArtworkDto()]
        
        //Exercise
        _ = tasks.map {
            ArtworkDao.add(model: $0)
        }
        
        //Verify
        verifyCount(count: 3)
    }
    /// 3つエンティティを追加し、ロードする際にURLで１つに絞り込む
    func testFindByUrl() {
        let expected = (count: 1, image: UIImage(named: "snow.jpg"))
        threeArtworks.forEach({ArtworkDao.add(model: $0)})
        let predicates = [
            NSPredicate(format: "url = %@", argumentArray: ["https://1.example.com"])
            ]
        let compoundedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let result = ArtworkDao.find(by: compoundedPredicate)
        
        XCTAssertEqual(result.count, expected.count)
        compareJpegImage(lhs: result.first?.image, rhs: expected.image)
    }
    /// LIKE句で、URLに関するワイルドカードを使って絞り込む
    func testFind3RecordByUrl() {
        let expected = 3
        threeArtworks.forEach({ArtworkDao.add(model: $0)})
        let predicate = NSPredicate(format: "url LIKE '*.example.com'")
        let result = ArtworkDao.find(by: predicate)
        XCTAssertEqual(result.count, expected)
    }
    func testFindURL() {
        let expected = (count: 1, image: UIImage(named: "snow.jpg"))
        threeArtworks.forEach({ArtworkDao.add(model: $0)})
        let predicate = NSPredicate(format: "url CONTAINS '2.example.com'")
        let result = ArtworkDao.find(by: predicate)
        XCTAssertEqual(result.count, expected.count)
        compareJpegImage(lhs: result[0].image, rhs: expected.image)
    }
}
extension XCTestCase {
    func verifyFirstItem(expectedId: Int,
                         expectedUrl: String,
                         expectedImage: UIImage?) {
        
        let result = ArtworkDao.findAll()
        let firstItem = result.first
        XCTAssertEqual(firstItem?.id, expectedId)
        
        if let resultUrl = firstItem?.url {
            XCTAssertEqual(resultUrl, expectedUrl)
        }
        compareJpegImage(lhs: firstItem?.image, rhs: expectedImage)
    }
    func verifyCount(count: Int) {
        let result = ArtworkDao.findAll()
        XCTAssertEqual(result.count, count)
    }
    /// JPEGのUIImageインスタンスを、base64エンコードした文字列に変換して比較する
    func compareJpegImage(lhs: UIImage?, rhs: UIImage?) {
        if lhs == nil, rhs == nil { return }
        guard let lImage = lhs, let rImage = rhs else { XCTFail("想定外のエラー"); return }
        XCTAssertTrue(lImage.base64EncodedStringFromJpeg == rImage.base64EncodedStringFromJpeg)
    }
    var threeArtworks: [ArtworkDto] {
        let object1 = ArtworkDto()
        object1.id = 1
        object1.url = "https://1.example.com"
        object1.image = UIImage(named: "snow.jpg")
        
        let object2 = ArtworkDto()
        object2.id = 2
        object2.url = "https://2.example.com"
        object2.image = UIImage(named: "snow.jpg")
        
        let object3 = ArtworkDto()
        object3.id = 3
        object3.url = "https://3.example.com"
        object3.image = UIImage(named: "spareribs.jpg")
        
        return [object1, object2, object3]
    }
}
extension UIImage {
    /// JPEG由来のUIImageのインスタンスを文字列に変換する
    /// seealso: https://qiita.com/silent0321/items/4253c20e43afdbed8638
    var base64EncodedStringFromJpeg: String? {
        guard let data = UIImageJPEGRepresentation(self, 0.0) else { return nil }
        //BASE64のStringに変換する
        return data.base64EncodedString(options: .lineLength64Characters)
    }
}
