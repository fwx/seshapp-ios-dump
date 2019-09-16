//
//  PlayerTrackCell.swift
//  SeshRadio
//
//  Created by spooky on 1/20/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

class PlayerTrackCell: FSPagerViewCell {
    @IBOutlet var trackImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clipsToBounds = false
    }
    
    func setImageUrl(_ url: URL?) {
        self.trackImage.sd_setImage(with: url, completed: nil)
    }
}
