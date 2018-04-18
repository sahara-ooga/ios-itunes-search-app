//
//  SearchResultVC+Artwork.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/17.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//
import Foundation

protocol DisplayArtwork: class {
    func display(artwork: Artwork,
                 at row: Int)
}
extension SearchResultVC: DisplayArtwork {
    func display(artwork: Artwork,
                 at row: Int) {
        let indexPath = IndexPath(row: row,
                                  section: 0)
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: ITunesCell.identifier,
                                 for: indexPath) as? ITunesCell else {
                                    fatalError("ITunesCellが取得できない。")
        }
        cell.artwork = artwork
//        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.reloadData()
    }
}
