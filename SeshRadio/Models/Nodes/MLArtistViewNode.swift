//
//  MLArtistViewNode.swift
//  SeshRadio
//
//  Created by spooky on 1/13/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MLArtistViewNode: ASCellNode {
    fileprivate var artist: Artist
    
    fileprivate let titleNode = ASTextNode()
    fileprivate let imageNode = ASNetworkImageNode()
    
    init(artist: Artist) {
        self.artist = artist
        
        super.init()
        
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
        
        self.setupNodes()
    }
    
    func setupNodes() {
        self.titleNode.attributedText = self.artist.name.createAttributed()
        self.imageNode.url = self.artist.avatarUrl
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageSize = constrainedSize.max.width * 0.2
        self.imageNode.cornerRadius = imageSize / 2
        self.imageNode.style.preferredSize = CGSize(width: imageSize, height: imageSize)
        
        let horizontalStack = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 8,
                                                justifyContent: .start,
                                                alignItems: .center,
                                                children: [self.imageNode, self.titleNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), child: horizontalStack)
    }
}
