//
//  ShowViewCell.swift
//  SeshRadio
//
//  Created by spooky on 12/16/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

class ShowViewCell: UITableViewCell {
    @IBOutlet var placeTitle: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var regionTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setShow(_ show: TourEvent) {
        self.placeTitle.text = show.place
        self.dateLabel.text = show.date
        self.regionTitle.text = "hmm"
    }
    
//    func setShow(_ show: Tour) {
//        self.showImage.sd_setImage(with: show.getImage(), completed: nil)
//        self.showTitle.text = show.getName()
//    }

}
