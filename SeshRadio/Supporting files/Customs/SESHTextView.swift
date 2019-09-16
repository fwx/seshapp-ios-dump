//
//  SESHTextView.swift
//  IphoneTests
//
//  Created by Andrew Lesovoy on 03.02.2018.
//  Copyright © 2018 Andrew Lesovoy. All rights reserved.
//  thanks to @ https://stackoverflow.com/a/45082349 | I hope there's a special place in heaven for this guy
//

import Foundation
import UIKit

class SESHTextView: UITextView {
    
    override var text: String! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        self.layoutManager.delegate = self
    }
    
    override func draw(_ rect: CGRect) {
        self.layoutManager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, self.text.count)) { (rect, usedRect, textContainer, glyphRange, Bool) in
            let rectanglePath = UIBezierPath(rect: CGRect(x: usedRect.origin.x, y: usedRect.origin.y, width: usedRect.size.width, height: usedRect.size.height))
            UIColor.black.setFill()
            rectanglePath.fill()
        }
    }
    
}


extension SESHTextView: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 15
    }
}
