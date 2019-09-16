//
//  IGLTeamSectionController.swift
//  SeshRadio
//
//  Created by spooky on 12/16/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import IGListKit

fileprivate let reuseIdentifier = "NewMemberCell"
fileprivate let linkHeight: CGFloat = 50
class IGLTeamSectionController: ListSectionController {
    fileprivate var actionController: UIAlertController?
    private var object: Member?
    private var expanded = false
    
    lazy var numberOfLinks: Int = {
        return self.object?.links.count ?? 0
    }()
    
    override func numberOfItems() -> Int {
        // if not expanded, return only first (name) cell
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
//        let width = collectionContext!.containerSize.width
//        return CGSize(width: width, height: width 15)
        
//        let width = collectionContext!.containerSize.width
//        if index == 0 {
//            return CGSize(width: width, height: 30)
//        } else if index > 0 && expanded {
//
//        }
        let width = collectionContext!.containerSize.width
        return expanded ? CGSize(width: width,
                                 height: CGFloat(self.numberOfLinks + 1) * linkHeight) : CGSize(width: width,
                                                                                          height: linkHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
//        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: reuseIdentifier, for: self, at: index) as? MemberViewCell else { fatalError() }
//
//        cell.memberLinksView.isHidden = !self.expanded
//        cell.memberLinksViewHeight.constant = CGFloat(self.numberOfLinks) * linkHeight
//        cell.bindViewModel(self.object!)
//
//        return cell
        
        fatalError()
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? Member
    }
    
    override func didSelectItem(at index: Int) {
        self.expanded = !self.expanded
        
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: 0.4,
//                       initialSpringVelocity: 0.6,
//                       options: [],
//                       animations: {
//                        self.collectionContext?.invalidateLayout(for: self)
//        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.layoutSubviews], animations: {
             self.collectionContext?.invalidateLayout(for: self)
        }) { (_) in
            self.collectionContext?.performBatch(animated: false, updates: { (batch) in
                batch.reload(self)
            }, completion: { (_) in
                
            })
        }
        
        
        
//        guard let member = self.object?.getMember(by: index) else { return }
//
//        let links = member.getLinks()
//
//        self.actionController?.dismiss(animated: true, completion: nil)
//        self.actionController = UIAlertController(title: nil, message: member.getName().uppercased(), preferredStyle: .actionSheet)
//
//
//        for link in links {
//            let linkAction = UIAlertAction(title: "\(link.getType().uppercased())", style: .default, handler: {
//                (alert: UIAlertAction!) -> Void in
//                guard let url = link.getLink() else { return }
//
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            })
//            self.actionController?.addAction(linkAction)
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.actionController?.dismiss(animated: true, completion: nil)
//        })
//
//        self.actionController?.addAction(cancelAction)
//        self.viewController?.present(self.actionController!, animated: true, completion: nil)
    }
}
