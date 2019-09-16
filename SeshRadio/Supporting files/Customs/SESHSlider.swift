//
//  SESHSlider.swift
//  SeshRadio
//
//  Created by spooky on 5/4/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit

class SESHSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        self.applyStyle()
    }
    
    private func applyStyle() {
        let image = UIImage()
        self.maximumValueImage = nil
        self.minimumValueImage = nil
        
        self.maximumTrackTintColor = UIColor(netHex: 0x1A1E23)
        
        self.setThumbImage(UIImage(named: "ic_thumb"), for: .normal)
        
    }
    
    
    
    
}
