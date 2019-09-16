//
//  FeaturedViewCell.swift
//  SeshRadio
//
//  Created by spooky on 1/3/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

class FeaturedViewCell: FSPagerViewCell {
    @IBOutlet var featuredImage: UIImageView!
    @IBOutlet var featuredTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setFeatured(_ featured: Featured) {
        self.featuredImage.sd_setImage(with: featured.pictureUrl, completed: nil)
        self.featuredTitle.text = featured.title
    }

}
