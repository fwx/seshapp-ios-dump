//
//  TrackViewCell.swift
//  SeshRadio
//
//  Created by spooky on 1/10/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import SDWebImage

class TrackViewCell: UICollectionViewCell {
    @IBOutlet var trackImage: UIImageView!
    
    func setTrackImage(_ image: URL?) {
        self.trackImage.sd_setImage(with: image, completed: nil)
    }
}
