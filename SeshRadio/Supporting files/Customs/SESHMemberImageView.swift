//
//  SESHMemberImageView.swift
//  SeshRadio
//
//  Created by spooky on 3/23/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class SESHMemberImageView: UIImageView {
    
    var gradientLayer: CAGradientLayer?
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.gradientLayer == nil {
            self.gradientLayer = CAGradientLayer()
            self.gradientLayer!.colors = [
                UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1).cgColor
            ]
            self.gradientLayer!.startPoint = CGPoint(x: 0, y: 0)
            self.gradientLayer!.endPoint = CGPoint(x: 1, y: 0)
            self.layer.mask = gradientLayer
        }
        CATransaction.begin()
        
        if let animation = self.layer.animation(forKey: "position") {
            CATransaction.setAnimationDuration(animation.duration)
            CATransaction.setAnimationTimingFunction(animation.timingFunction)
        } else {
            CATransaction.disableActions()
        }
        
        self.gradientLayer!.frame = self.bounds
        
        
        CATransaction.commit()

    }
}
