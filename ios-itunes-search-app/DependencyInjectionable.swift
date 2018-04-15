//
//  DependencyInjectionable.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

protocol DependencyInjectionable {
    associatedtype Dependency
    var dependency: Dependency { get }
    init(dependency: Dependency)
}
