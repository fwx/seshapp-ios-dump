//
//  AlbumViewCell.swift
//  SeshRadio
//
//  Created by spooky on 1/3/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

class AlbumViewCell: FSPagerViewCell {
    @IBOutlet var albumImage: UIImageView!
    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var albumArtist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clipsToBounds = false
    }
    
    func setAlbum(_ album: Album) {
        self.albumTitle.text = album.title
        self.albumArtist.text = album.artistsConcated
        
        
        self.albumImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.albumImage.sd_setImage(with: album.albumCover) { (_, _, _, _) in
            //self.albumImage.sd_removeActivityIndicator()
        }
    }

}
