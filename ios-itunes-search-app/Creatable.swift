//
//  Creatable.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/21.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//
import UIKit
protocol Creatable {
    associatedtype Dependency
    static func create(dependency: Dependency) -> Self
}
protocol Identifiable { }
extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
protocol CreatableVC: class, Creatable, Identifiable {
    var dependency: Dependency { get set }
}
extension CreatableVC {
    /// <VCの名前>.storyboardが存在するVCの場合、VC自身を返す
    static func create(dependency: Dependency) -> Self? {
        let vc = UIStoryboard(name: self.identifier, bundle: nil).instantiateInitialViewController() as? Self
        vc?.dependency = dependency
        return vc
    }
}
