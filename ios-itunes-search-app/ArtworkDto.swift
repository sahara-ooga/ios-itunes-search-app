//
//  ArtworkDto.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/09.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//
import UIKit
import RealmSwift

class ArtworkDto: Object {
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    
    @objc dynamic private var _image: UIImage? = nil
    @objc dynamic private var imageData: Data? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
}

extension ArtworkDto {
    @objc dynamic var image: UIImage?{
        set{
            //imageにsetすると、自動的に_imageに値が保持され、imageDataにも変換&setされる。
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
}
