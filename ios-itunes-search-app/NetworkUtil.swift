//
//  NetworkUtil.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//
import Reachability

enum Connnectibity {
    case none
    case cellular
    case wifi
    case reachabilityInitError
}

protocol ConnnectibityCheckable {
    /// - NOTE: 動的ディスパッチにするためには、デフォルト実装だけでなくメソッドの定義が必要
    func connectivity() -> Connnectibity
}

extension ConnnectibityCheckable {
    func connectivity() -> Connnectibity {
        guard let reachability = Reachability() else {
            return .reachabilityInitError
        }
        
        switch reachability.connection {
        case .none:
            return .none
        case .cellular:
            return .cellular
        case .wifi:
            return .wifi
        }
    }
}

struct NetworkUtil { }
extension NetworkUtil: ConnnectibityCheckable { }
