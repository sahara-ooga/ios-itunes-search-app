//
//  ArtworkResponseError.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/08.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

enum ArtworkResponseError: Error {
    case ressponseIsNil
    case dataIsNil
    case imageTranslation
    case imageDownload(Error)
}
