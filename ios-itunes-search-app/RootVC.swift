//
//  RootVC.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/03/23.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
// MARK: Search Bar
extension RootVC {
    func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.keyboardType = .default
    }
}
extension RootVC: UISearchBarDelegate {
    /// 検索をクリックしたときに呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        if let searchText = searchBar.text {
            print("searchText:\(searchText)")
        }
    }
    /// サーチバーの中身が更新されるときに呼ばれる
    /// 日本語入力の場合、確定ボタンを押す・文字を削除するタイミングで呼ばれる
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        print(#function)
        print(searchText)
    }
    /// キャンセルボタンをクリックしたときに呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
