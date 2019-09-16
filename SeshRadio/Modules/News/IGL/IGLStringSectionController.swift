//
//  IGLStringSectionController.swift
//  SeshRadio
//
//  Created by spooky on 9/5/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import IGListKit

fileprivate let kCellIdentifier = "StringCell"

class IGLStringSectionController: ListSectionController {
    private var object: FeedString?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 64)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let object = self.object else { fatalError() }
        
        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: kCellIdentifier, for: self, at: index) as? FeedCategoryCell else {
            fatalError()
        }
        
        cell.bindViewModel(object.base)
        
        return cell
        
        //        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: kCellIdentifier, for: self, at: index) as? UICollectionViewCell
        //            , let news = self.object else {
        //                fatalError()
        //        }
        
//        guard let cell = collectionContext?
//            .dequeueReusableCellFromStoryboard(withIdentifier: kCellIdentifier, for: self, at: index) as? FeedToursViewCell else {
//                fatalError()
//        }
//        
//        guard let model = self.object else {
//            fatalError()
//        }
//        
//        cell.bindViewModel(model.tours)
//        
//        //        cell.bindViewModel(news)
//        //        cell.setShareDelegate(self.shareDelegate)
//        //
 
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? FeedString
    }
}
