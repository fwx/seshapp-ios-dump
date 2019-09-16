//
//  StationViewCell.swift
//  SeshRadio
//
//  Created by spooky on 4/28/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

class StationViewCell: FSPagerViewCell {
    @IBOutlet var stationCover: UIImageView!
    @IBOutlet var stationTitle: UILabel!
    
    private func setSelection() {
        let result = self.isSelected == true
        
        
        //trackImageHolder
        let transform = CGAffineTransform(scaleX: result ? 1 : 0.7, y: result ? 1 : 0.7)
        UIView.animate(withDuration: 0.5) {
            self.stationCover.transform = transform
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.stationCover.layer.cornerRadius = 10
        self.isSelected = false
        // Initialization code
    }
    
    func setImage(_ imageUrl: URL?) {
        self.stationCover.sd_setImage(with: imageUrl, completed: nil)
    }
    
    func setTitle(_ title: String) {
        self.stationTitle.text = title
    }

    
    override var isSelected: Bool {
        didSet {
            self.setSelection()
        }
    }
}
