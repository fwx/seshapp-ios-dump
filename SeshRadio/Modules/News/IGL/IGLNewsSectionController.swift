//
//  IGLNewsSectionController.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import IGListKit

fileprivate let kCellIdentifier = "NewsCell"
class IGLNewsSectionController: ListSectionController {
    private var object: News?
    var selectionDelegate: PrimitiveSelection?
    var shareDelegate: ShareProtocol!
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: width + 50)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: kCellIdentifier, for: self, at: index) as? NewsViewCell
            , let news = self.object else {
            fatalError()
        }
        
        cell.bindViewModel(news)
        cell.setShareDelegate(self.shareDelegate)
        
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? News
    }
    
    override func didSelectItem(at index: Int) {
        self.selectionDelegate?.onSelected?(object: self.object)
    }
}
