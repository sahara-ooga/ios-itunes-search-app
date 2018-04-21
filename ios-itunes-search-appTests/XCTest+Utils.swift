//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Snips
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
import XCTest
// swiftlint:disable force_cast force_try vertical_parameter_alignment
extension XCTestCase {
    static func jsonDataFromFile(_ filename: String) -> Data? {
        let jsonPath = Bundle(for: self).path(forResource: filename, ofType: "json")
        return try? Data(contentsOf: URL(fileURLWithPath: jsonPath!))
    }
    
    static func jsonFromFile(_ filename: String) -> [String: AnyObject] {
        let jsonPath = Bundle(for: self).path(forResource: filename, ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        return try! JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyObject]
    }
    
    static func jsonArrayFromFile(_ filename: String) -> [[String: AnyObject]] {
        let jsonPath = Bundle(for: self).path(forResource: filename, ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        return try! JSONSerialization.jsonObject(with: jsonData!, options: []) as! [[String: AnyObject]]
    }
}
extension XCTestCase {
    // NOTE: Xcode9の挙動で、可変長引数の後の引数の位置が調整されてしまう（のでリントに引っかかる）
    static func logPrint(strings: String...,
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function) {
        print("logPrint>>>>>>>>>>>>>>>>>>>>>>")
        print("file:", file)
        print("line:", line)
        print("column:", column)
        print("function:", function)
        
        for string in strings {
            print(string)
        }
        
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    }
}
