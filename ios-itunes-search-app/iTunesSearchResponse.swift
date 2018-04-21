//
//  iTunesSearchResponse.swift
//  ios-swiftbond-sample
//
//  Created by yogasawara@stv on 2018/04/02.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import Foundation

struct iTunesSearchResponse: Codable {
    let resultCount: Int
    let results: [iTunesTrack]
}

struct iTunesTrack: Codable {
    private let artistID: Int
    let artistName: String
    private let artistViewURL: String
    let artworkUrl100: String
    private let artworkUrl30: String
    private let artworkUrl60: String
    private let collectionCensoredName: String
    private let collectionExplicitness: String
    private let collectionID: Int
    private let collectionName: String
    private let collectionPrice: Double
    private let collectionViewURL: String
    private let country: String
    private let currency: String
    private let discCount: Int
    private let discNumber: Int
    private let isStreamable: Bool
    private let kind: String
    private let previewURL: String
    private let primaryGenreName: String
    private let releaseDate: String
    private let trackCensoredName: String
    private let trackCount: Int
    private let trackExplicitness: String
    private let trackID: Int
    let trackName: String
    private let trackNumber: Int
    private let trackPrice: Double
    private let trackTimeMillis: Int
    private let trackViewURL: String
    private let wrapperType: String
    
    enum CodingKeys: String, CodingKey {
        case artistID = "artistId"
        case artistName = "artistName"
        case artistViewURL = "artistViewUrl"
        case artworkUrl100 = "artworkUrl100"
        case artworkUrl30 = "artworkUrl30"
        case artworkUrl60 = "artworkUrl60"
        case collectionCensoredName = "collectionCensoredName"
        case collectionExplicitness = "collectionExplicitness"
        case collectionID = "collectionId"
        case collectionName = "collectionName"
        case collectionPrice = "collectionPrice"
        case collectionViewURL = "collectionViewUrl"
        case country = "country"
        case currency = "currency"
        case discCount = "discCount"
        case discNumber = "discNumber"
        case isStreamable = "isStreamable"
        case kind = "kind"
        case previewURL = "previewUrl"
        case primaryGenreName = "primaryGenreName"
        case releaseDate = "releaseDate"
        case trackCensoredName = "trackCensoredName"
        case trackCount = "trackCount"
        case trackExplicitness = "trackExplicitness"
        case trackID = "trackId"
        case trackName = "trackName"
        case trackNumber = "trackNumber"
        case trackPrice = "trackPrice"
        case trackTimeMillis = "trackTimeMillis"
        case trackViewURL = "trackViewUrl"
        case wrapperType = "wrapperType"
    }
}

// MARK: Convenience initializers

extension iTunesSearchResponse {
    init(data: Data) throws {
        self = try JSONDecoder().decode(iTunesSearchResponse.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension iTunesTrack {
    init(data: Data) throws {
        self = try JSONDecoder().decode(iTunesTrack.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
