//
//  Constants.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//
import UIKit

struct Constants {
    struct Alert {
        typealias Info = (title: String, message: String)
        static let noConnection: Info = (title:"警告",
                                         message: "通信環境の良い場所で再度お試しください。")
    }
    enum ConnectionState {
        case noConnection
        case nomal
    }
    /// 通信状況を切り替えるフラグ
    static let connectionState: ConnectionState = .nomal
    
    static let defaultCellHeight: CGFloat = 70.0
    static let defaultTrackNum = 100
}
