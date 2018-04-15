//
//  Constants.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//
struct Constants {
    struct Alert {
        typealias Info = (title: String, message: String)
        static let noConnection: Info = (title:"警告", message: "通信環境の良い場所で再度お試しください。")
    }
    enum ConnectionState {
        case noConnection
        case nomal
    }
    static let connectionState: ConnectionState = .nomal
}
