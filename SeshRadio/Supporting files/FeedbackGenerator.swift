//
//  FeedbackGenerator.swift
//  SeshRadio
//
//  Created by spooky on 7/14/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit

class FeedBackGenerator {
    static let shared = FeedBackGenerator()
    
    lazy fileprivate var notificationGenerator: UINotificationFeedbackGenerator = {
        return UINotificationFeedbackGenerator()
    }()
    
    lazy fileprivate var selectionGenerator: UISelectionFeedbackGenerator = {
        return UISelectionFeedbackGenerator()
    }()
    
    init() { }
    
    func selection() {
        self.selectionGenerator.prepare()
        self.selectionGenerator.selectionChanged()
    }
    
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        DispatchQueue.main.async {
            var generator: UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: style)
            generator?.impactOccurred()
            
            // dispose memory
            generator = nil
        }
        
    }
    
    func notification(with style: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(style)
    }
}
