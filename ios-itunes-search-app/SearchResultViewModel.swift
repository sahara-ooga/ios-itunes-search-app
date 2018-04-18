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
    func didReceive(artwork: Artwork, at index: Int)
    func didReceive(error: APIKit.SessionTaskError)
}
protocol SearchResultVMProtocol {
    func search(query: String, limit: Int)
    func fetchArtwork(from searchResult: iTunesSearchResponse)//, onArtwork: (Artwork) -> Void)
    func fetchArtwork(at index: Int, of track: iTunesTrack)
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
    func search(query: String, limit: Int = 50) {
        let iRepo = dependency.iTunesRepo
        iRepo.search(query: query,
                     limit: limit) { [weak self] result in
                        switch result {
                        case .success(let itunesResponse):
                            self?.tracks.append(contentsOf: itunesResponse.results)
                            self?.delegate?.didReceive(tracks: itunesResponse.results)
                            //検索結果を受け取ったら、画像の取得処理を開始する
//                            itunesResponse.results.enumerated().forEach { (index, track) in
//                                self?.fetchArtwork(at: index, of : track)
//                            }
                        case .failure(let error):
                            self?.delegate?.didReceive(error: error)
                        }
        }
    }
    func fetchArtwork(from searchResult: iTunesSearchResponse) {
        searchResult.results.enumerated().forEach { [weak self] (index,track) in
            self?.fetchArtwork(at: index, of : track)
        }
    }
    func fetchArtwork(at index: Int, of track: iTunesTrack) {
        let artworkRepo = dependency.artworkRepo
        artworkRepo.artwork(in: track.artworkUrl100) { [weak self] result in
            switch result {
            case .success(let artwork):
                //番号とartworkをデリゲートに通知
                self?.delegate?.didReceive(artwork: artwork, at: index)
            case .failure(let error):
                //デリゲートに通知
                self?.delegate?.didReceive(error: error)
            }
        }
    }
}
