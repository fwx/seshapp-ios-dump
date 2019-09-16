//
//  SPKNavigationController.swift
//  SeshRadio
//
//  Created by spooky on 8/18/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit

class SPKNavigationController: UINavigationController, UINavigationControllerDelegate {
    private var popCompletion: ((UIViewController) -> ())? = nil
 
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        print("completion")
        
        self.popCompletion?(viewController)
        self.popCompletion = nil
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setDelegate()
    }
    
    private func setDelegate() {
        self.delegate = self
    }
    
    @discardableResult
    func popViewController(animated: Bool, completion: ((UIViewController) -> ())? = nil) -> UIViewController? {
        //self.popCompletion = completion
        self.popCompletion = completion
        
        return self.popViewController(animated: animated)
    }
}
