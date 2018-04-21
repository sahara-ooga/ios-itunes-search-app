//
//  SearchResultVC.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var tracks: [iTunesTrack] = []
    var artworks: [Int: Artwork] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = Constants.defaultCellHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: ITunesCell.identifier,
                                 for: indexPath) as? ITunesCell else {
                                    fatalError("ITunesCellが取得できない。")
        }
        cell.itunesTrack = tracks[indexPath.row]
        
        if let artwork = artworks[indexPath.row] {
            cell.artwork = artwork
        }
        // NOTE: 途中は画像の取得・表示処理をここでやっていたのだが、上手くいかず
            //   他のデータソースから流し込むフローでないとうまくいかない
        return cell
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.defaultCellHeight
    }
}
