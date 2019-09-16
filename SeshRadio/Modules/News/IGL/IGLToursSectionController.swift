//
//  IGLToursSectionController.swift
//  SeshRadio
//
//  Created by spooky on 9/3/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import IGListKit

fileprivate let kCellIdentifier = "ToursCell"

class IGLToursSectionController: ListSectionController {
    private var object: FeedTours?
    var selectionDelegate: PrimitiveSelection?
    weak var shareDelegate: ShareProtocol!
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 225)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
//        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: kCellIdentifier, for: self, at: index) as? UICollectionViewCell
//            , let news = self.object else {
//                fatalError()
//        }
        
        guard let cell = collectionContext?
            .dequeueReusableCellFromStoryboard(withIdentifier: kCellIdentifier, for: self, at: index) as? FeedToursViewCell else {
                fatalError()
        }
        
        guard let model = self.object else {
            fatalError()
        }
        
        cell.bindViewModel(model.tours)
        cell.selectionDelegate = self.selectionDelegate
        
//        cell.bindViewModel(news)
//        cell.setShareDelegate(self.shareDelegate)
//
        
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? FeedTours
    }
    
    override func didSelectItem(at index: Int) {
        //self.selectionDelegate?.onSelected?(object: self.object)
    }
}
