//
//  PlayerNavViewController.swift
//  SeshRadio
//
//  Created by spooky on 5/4/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit

class PlayerNavViewController: UINavigationController {

//    lazy var holderView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isUserInteractionEnabled = false
//        view.backgroundColor = .red
//
//        return view
//    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        self.view.addSubview(self.holderView)
//
//        NSLayoutConstraint.activate([
//            self.holderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
//            self.holderView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
//            self.holderView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
//            self.holderView.heightAnchor.constraint(equalToConstant: 150)
//            ])
    }
    

    override var viewForPopupInteractionGestureRecognizer: UIView {
        return self.view
    }

}

extension PlayerNavViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print ( "gay" )
        if otherGestureRecognizer.view is UIScrollView {
            return false
        }
        
        return true
    }
    
    
}
