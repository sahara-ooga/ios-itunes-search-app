//
//  DecodableDataParser.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import Foundation
import APIKit

final class DecodableDataParser: DataParser {
    var contentType: String? {
        return "application/json"
    }
    
    /// 受け取ったDataをそのまま返却
    func parse(data: Data) throws -> Any {
        return data
    }
}
