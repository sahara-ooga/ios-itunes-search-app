//
//  Artwork.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import UIKit
import RepositoryTool

struct Artwork {
    let id: Int
    let url: String
    let image: UIImage?

    init(from dto: ArtworkDto) {
        self.id = dto.id
        self.url = dto.url
        self.image = dto.image
    }
}
