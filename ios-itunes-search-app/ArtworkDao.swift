//
//  ArtworkDao.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/09.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import Foundation
import RealmSwift

protocol DtoProtocol {
    associatedtype Identifier
    var id: Identifier { get }
}
protocol DaoProtocol {
    associatedtype Dto: DtoProtocol
    static func add(model: Dto) -> Int
    static func update(model: Dto) -> Bool
    static func update(model: Dto,
                       transaction: @escaping () -> Void) -> Bool
    static func delete(id: Dto.Identifier)
    static func deleteAll()
    static func find(by id: Dto.Identifier) -> Dto?
    static func findAll() -> [Dto]
}
protocol PredicateDaoProtocol: DaoProtocol {
    static func find(by predicate: NSPredicate) -> [Dto]
}
final class ArtworkDao: DaoProtocol {
    private static let dao = RealmDaoHelper<ArtworkDto>()
    typealias Dto = ArtworkDto
    /// DBにオブジェクトを追加して、発行されたIDを返却する
    ///
    /// - Parameter model: DBに追加したいオブジェクト
    /// - Returns: DBに追加したオブジェクトに発行されたID
    @discardableResult static func add(model: ArtworkDto) -> Int {
        let object = ArtworkDto()
        object.id = ArtworkDao.dao.newId()!
        object.url = model.url
        object.image = model.image
        ArtworkDao.dao.add(d: object)
        return object.id
    }
    static func add(_ dto: ArtworkDto) -> ArtworkDto {
        let object = ArtworkDto()
        object.id = ArtworkDao.dao.newId()!
        object.url = dto.url
        object.image = dto.image
        ArtworkDao.dao.add(d: object)
        return object
    }
    @discardableResult static func update(model: ArtworkDto) -> Bool {
        guard let object = dao.findFirst(key: model.id as AnyObject) else {
            return false
        }
        object.url = model.url
        object.image = model.image
        return dao.update(d: object)
    }
    /// レコードの更新処理
    ///
    /// - Parameters:
    ///   - model: 更新したいオブジェクト
    ///   - transaction: 更新したいオブジェクトの更新処理　トランザクションのブロックで実行される
    /// - Returns: 成功時true
    @discardableResult static func update(model: ArtworkDto,
                                          transaction: @escaping () -> Void) -> Bool {
        return dao.update(d: model, block: transaction)
    }
    static func delete(id: Int) {
        guard let object = dao.findFirst(key: id as AnyObject) else {
            return
        }
        dao.delete(d: object)
    }
    
    static func deleteAll() {
        dao.deleteAll()
    }
    
    static func find(by id: Int) -> ArtworkDto? {
        guard let object = dao.findFirst(key:id as AnyObject) else {
            return nil
        }
        return object
    }
    
    static func findAll() -> [ArtworkDto] {
        let objects =  ArtworkDao.dao.findAll()
        return objects.map { ArtworkDto(value: $0) }
    }
}

extension ArtworkDao: PredicateDaoProtocol {
    static func find(by predicate: NSPredicate) -> [ArtworkDto] {
        return ArtworkDao.dao.find(by: predicate).map({ArtworkDto(value: $0)})
    }
    static func find(by predicate: String) -> [ArtworkDto] {
        return ArtworkDao.dao.find(by: predicate).map({ArtworkDto(value: $0)})
    }
}
