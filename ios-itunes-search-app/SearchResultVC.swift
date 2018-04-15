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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
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
        if !tracks.isEmpty {
            cell.itunesTrack = tracks[indexPath.row]
        }
        return cell
    }
}
