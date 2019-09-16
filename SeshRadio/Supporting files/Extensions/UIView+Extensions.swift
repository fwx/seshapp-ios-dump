//
//  UIView+Extensions.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import UIKit

enum UIViewDropShadow {
    case left
    case right
    case top
    case bottom
}

extension UIView {
    func round(cornerRadius: CGFloat = 5.0) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    
    func roundCorners(_corners: UIRectCorner = [.topRight, .bottomRight], value: CGFloat = 10, border: Bool = false, borderColor: UIColor = UIColor.white, borderWidth: CGFloat = 1){
        if(border){
            //self.backgroundColor = UIColor.clearColor()
            self.layer.cornerRadius = value
            self.layer.borderWidth = borderWidth
            //self.layer.opacity = 1
            self.layer.borderColor = borderColor.cgColor
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: _corners, cornerRadii: CGSize(width: value, height: value))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
            self.layer.masksToBounds = true
        }
        
        
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.red.cgColor
        
        let realFrame = self.frame
        let padding: CGFloat = 15
        let path = UIBezierPath(rect: CGRect(x: realFrame.minX + padding, y: realFrame.minY, width: realFrame.maxX - (padding * 2), height: realFrame.maxY))
       
        self.layer.shadowPath = path.cgPath
        
        
    }
    
    @nonobjc class var defaultOnePixelConversion: CGFloat {
        return 1.0 / UIScreen.main.scale
    }
}
