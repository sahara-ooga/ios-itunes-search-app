//
//  ITunesCell.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import UIKit

class ITunesCell: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    @IBOutlet weak var artworkView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var itunesTrack: iTunesTrack? {
        didSet {
            titleLabel.text = itunesTrack?.trackName
        }
    }
    var artwork: Artwork? {
        didSet {
            artworkView.image = artwork?.image
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        // セルが画像をキャッシュして、同じ画像が表示されてしまうので初期化
        self.itunesTrack = nil
        self.artwork = nil
    }
}
