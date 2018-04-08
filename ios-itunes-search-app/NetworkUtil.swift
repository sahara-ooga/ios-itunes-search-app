//
//  NetworkUtil.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//


struct NetworkUtil { }

// MARK: - Reachability
import Reachability

extension NetworkUtil {
    enum Connnectibity {
        case none
        case cellular
        case wifi
        case reachabilityInitError
    }
    
    static func connectivity() -> Connnectibity {
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


