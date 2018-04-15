//
//  NSObject+Util.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/16.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import Foundation
extension NSObject {
    static func logPrint(_ strings:String...,
        file:String = #file,
        line:Int = #line,
        column:Int = #column,
        function:String = #function){
        print("logPrint>>>>>>>>>>>>>>>>>>>>>>")
        print("file:",file)
        print("line:",line)
        print("column:",column)
        print("function:",function)
        
        for string in strings {
            print(string)
        }
        
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    }
}
