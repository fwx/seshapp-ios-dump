//
//  RoundedUIImageView.swift
//  SeshRadio
//
//  Created by spooky on 12/18/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import UIKit


class RoundedUIImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = 1
            layer.shadowOffset = CGSize.zero
            clipsToBounds = false
        }
    }
    @IBInspectable var shadowcolor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowcolor.cgColor
        }
    }
}
