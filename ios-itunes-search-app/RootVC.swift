//
//  RootVC.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/03/23.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import UIKit
import APIKit

class RootVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultView: UIView!
    var searchResultViewModel: SearchResultVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVCs()
        setUpViewModel()
        setUpSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - ViewModel
extension RootVC {
    func setUpViewModel() {
        let apiClient = iTunesSearchAPIClient(dependency: NetworkUtil())
        let iTunesRepo = iTunesRepository(dependency: (apiClient))
        let artworkRepo = ArtworkRepository(dependency: ArtworkClient(dependency: (NetworkUtil())))
        let searchResultViewModel = SearchResultViewModel(dependency: (iTunesRepo: iTunesRepo,
                                                                       artworkRepo: artworkRepo))
        searchResultViewModel.delegate = self
        self.searchResultViewModel = searchResultViewModel
    }
}
// MARK: - Display View Controller(s)
extension RootVC {
    func setUpVCs() {
        do {
            //EmptyVCをセットする
            let storyboard = UIStoryboard(name: EmptyResultVC.identifier,
                                          bundle: nil)
            let emptyVC = storyboard.instantiateInitialViewController() as! EmptyResultVC
            emptyVC.view.isHidden = true
            self.addChildViewController(emptyVC)
            self.resultView.addSubview(emptyVC.view)
        }
        do {
            //検索結果のVCをセットする
            let storyboard = UIStoryboard(name: SearchResultVC.identifier,
                                          bundle: nil)
            let searchResultVC = storyboard.instantiateInitialViewController() as! SearchResultVC
            searchResultVC.view.isHidden = true
            self.addChildViewController(searchResultVC)
            self.resultView.addSubview(searchResultVC.view)
        }
    }
    func display(vc: DestinationVC, tracks: [iTunesTrack]) {
        switch vc {
        case .empty:
            let emptyView = self.resultView.subviews.first
            let searchResultView = self.resultView.subviews[1]
            emptyView?.isHidden = false
            searchResultView.isHidden = true
        case .searchResult:
            let searchResultVC = self.childViewControllers[1] as! SearchResultVC
            searchResultVC.tracks = tracks
            let emptyView = self.resultView.subviews.first
            let searchResultView = self.resultView.subviews[1]
            emptyView?.isHidden = true
            searchResultView.isHidden = false
            searchResultVC.tableView.reloadData()
        }
    }
}
extension RootVC: SearchResultDelegate {
    func didReceive(tracks: [iTunesTrack]) {
        if tracks.isEmpty {
            display(vc: .empty, tracks: tracks)
        } else {
            display(vc: .searchResult, tracks: tracks)
        }
    }
    func didReceive(index: Int, artwork: Artwork) {
        //TODO: 後でやる
    }
    func didReceive(error: SessionTaskError) {
        //TODO: 後でやる
        //TODO: 通信エラー時のアラート表示への導線を引く
//        switch error {
//        case .connectionError(let error):
//            //アラートを表示する
//        default:
//            <#code#>
//        }
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
        if let searchBarText = searchBar.text {
            print("searchText:\(searchBarText)")
            //空白は+に置換
            let searchText = searchBarText.replacingOccurrences(of: " ", with: "+")
            self.searchResultViewModel.search(query: searchText, limit: 5)
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
