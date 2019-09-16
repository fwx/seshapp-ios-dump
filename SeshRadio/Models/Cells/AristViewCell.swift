//
//  AristViewCell.swift
//  SeshRadio
//
//  Created by spooky on 1/3/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

class ArtistViewCell: FSPagerViewCell {
    @IBOutlet var artistImage: UIImageView!
    @IBOutlet var artistTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
    }

    
    func setArtist(_ artist: Artist) {
        self.artistTitle.text = artist.name
   
        self.artistImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.artistImage.sd_setImage(with: artist.avatarUrl) { (_, _, _, _) in
            //self.artistImage.sd_removeActivityIndicator()
        }
        
    }
}
