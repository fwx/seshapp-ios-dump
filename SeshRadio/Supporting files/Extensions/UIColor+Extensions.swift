//
//  UIColors+Extensions.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    @nonobjc class var navBar: UIColor {
        return UIColor(netHex: 0x20252B)
    }
    
    @nonobjc class var navBarTint: UIColor {
        return UIColor(netHex: 0x20252B)
    }
    
    @nonobjc class var seshTabBar: UIColor {
        return UIColor(netHex: 0x121212)
    }
    
    @nonobjc class var gradientColors: [CGColor] {
        return [UIColor(netHex: 0x753033).cgColor, UIColor(netHex: 0x375574).cgColor]
    }
    
    @nonobjc class var miniPlayerColorBg: UIColor {
        return UIColor(netHex: 0x232323)
    }
    
    @nonobjc class var miniPlayerColorTint: UIColor {
        return UIColor.lightGray
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
}
