//
//  SearchResultViewModel.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import Foundation
import Result
import APIKit

protocol SearchResultDelegate: class {
    func didReceive(tracks: [iTunesTrack])
    func didReceive(index: Int, artwork: Artwork)
    func didReceive(error: APIKit.SessionTaskError)
}
protocol SearchResultVMProtocol {
    func search(query: String, limit: Int)
    func fetchArtwork(from url:String, track: iTunesTrack)
}
final class SearchResultViewModel: DependencyInjectionable {
    typealias Dependency = (iTunesRepo: iTunesRepositoryProtocol,
                            artworkRepo: ArtworkRepositoryProtocol)
    var dependency: (iTunesRepo: iTunesRepositoryProtocol,
                     artworkRepo: ArtworkRepositoryProtocol)
    weak var delegate: SearchResultDelegate?
    var tracks: [iTunesTrack] = []
    required init(dependency: (iTunesRepo: iTunesRepositoryProtocol,
        artworkRepo: ArtworkRepositoryProtocol)) {
        self.dependency = dependency
    }
}
extension SearchResultViewModel: SearchResultVMProtocol {
    func search(query: String,limit: Int = 50) {
        let iRepo = dependency.iTunesRepo
        iRepo.search(query: query,
                     limit: limit) { [weak self] result in
                        switch result {
                        case .success(let itunesResponse):
                            self?.tracks.append(contentsOf: itunesResponse.results)
                            self?.delegate?.didReceive(tracks: itunesResponse.results)
                        case .failure(let error):
                            self?.delegate?.didReceive(error: error)
                        }
        }
    }
    func fetchArtwork(from url:String, track: iTunesTrack) {
        let artworkRepo = dependency.artworkRepo
        artworkRepo.artwork(in: url) { [weak self] result in
            switch result {
            case .success(let artwork):
                print("TODO: 画像が届いた際の処理")
                //tracksから対応するセルの番号を取得
                guard let index = self?.tracks.index(where: { t in
                    return t.artworkUrl100 == track.artworkUrl100
                        && t.trackName == track.trackName
                        && t.artistName == track.artistName
                }) else {
                    assertionFailure("URLに対応するトラックがない"); return
                }
                //番号とartworkをデリゲートに通知
                self?.delegate?.didReceive(index: index, artwork: artwork)
            case .failure(let error):
                //デリゲートに通知
                self?.delegate?.didReceive(error: error)
            }
        }
    }
}
