//
//  TourViewCell.swift
//  SeshRadio
//
//  Created by spooky on 9/7/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import FSPagerView

class TourViewCell: FSPagerViewCell {
    @IBOutlet var tourImage: RoundedUIImageView!
    @IBOutlet var tourTitle: UILabel!
    
    func setTour(_ tour: Tour) {
        self.tourImage.sd_setImage(with: tour.imageUrl, completed: nil)
        self.tourTitle.text = tour.name
    }
}
