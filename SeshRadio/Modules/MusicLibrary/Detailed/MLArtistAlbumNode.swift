//
//  MLArtistAlbumNode.swift
//  SeshRadio
//
//  Created by spooky on 4/16/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import FSPagerView

class MLArtistAlbumNode: ASDisplayNode {
    init(height: CGFloat, dataSource: FSPagerViewDataSource,
         delegate: FSPagerViewDelegate) {
        super.init()
        
        self.setViewBlock { () -> UIView in
            let view = FSPagerView(frame: CGRect(x: 0, y: 0, width: 0, height: height))
            view.dataSource = dataSource
            view.delegate = delegate
            view.register(UINib(nibName: kAlbumCellIdentifier,
                                                bundle: nil),
                                          forCellWithReuseIdentifier: kAlbumCellIdentifier)
            view.itemSize = CGSize(width: height, height: height)
            view.interitemSpacing = 15
            return view
        }
        
        self.style.height = .init(unit: .points, value: height)
    }
}

class MLArtistAlbumHolder: ASCellNode {
    var pager: FSPagerView? {
        return self.node.view as? FSPagerView
    }
    
    let node: MLArtistAlbumNode
    
    init(height: CGFloat = 180, dataSource: FSPagerViewDataSource,
         delegate: FSPagerViewDelegate) {
        self.node = MLArtistAlbumNode(height: height,
                                      dataSource: dataSource,
                                      delegate: delegate)
        super.init()
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0), child: self.node)
    }
}
