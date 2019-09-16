//
//  CRView.swift
//  SeshRadio
//
//  Created by spooky on 5/5/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit


class CRView: UIView {
    private var shadowLayer: CAShapeLayer!
    @IBInspectable var cornerRadius: CGFloat = 25.0
    
    @IBInspectable var shadow: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            if shadow {
                shadowLayer.shadowColor = UIColor.black.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                shadowLayer.shadowOpacity = 0.7
                shadowLayer.shadowRadius = 10
            }
            
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        
        if shadow {
            shadowLayer.shadowPath = shadowLayer.path
        }
        
    }
}
