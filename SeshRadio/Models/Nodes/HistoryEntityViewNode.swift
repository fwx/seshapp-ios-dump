//
//  MLAlbumViewNode.swift
//  SeshRadio
//
//  Created by spooky on 1/10/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import AsyncDisplayKit


class HistoryEntityViewNode: ASCellNode {
    private var historyEntity: HistoryEntity!
    
    private let titleNode = ASTextNode()
    private let subTitleNode = ASTextNode()
    private let descriptionNode = ASTextNode()
    private let imageNode = ASNetworkImageNode()
    private let actionButton = ASButtonNode() // todo replace with asimagenode
    
    var delegate: PrimitiveSelection?
    private var hideCover = false
    
    init(data: HistoryEntity) {
        self.hideCover = true
        self.historyEntity = data
        
        super.init()
        
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
        
        
        self.createNodes()
    }
    
    
    func createNodes() {
        var title = ""
        var subtitle = ""
        var description = ""
        
        guard let track = self.historyEntity.song else {
            return
        }
        
        
        title = track.title
        subtitle = track.artistsConcacted
        description = String(format: "%@ - %@",
                             self.historyEntity.startTime?.asLocalDate?.toFormat("HH:mm") ?? "",
                             self.historyEntity.endTime?.asLocalDate?.toFormat("HH:mm") ?? "")
       
        actionButton.setTitle("...", with: nil, with: .lightGray, for: .normal)
        actionButton.addTarget(self,
                               action: #selector(self.onOptions),
                               forControlEvents: .touchUpInside)
        
        self.imageNode.contentMode = .scaleToFill
        self.titleNode.maximumNumberOfLines = 1
        
        self.titleNode.attributedText = title
            .createAttributed(fontSize: 16, fontColor: .white)
        self.subTitleNode.attributedText = subtitle
            .createAttributed(fontSize: 14, fontColor: .lightGray)
        self.descriptionNode.attributedText = description
            .createAttributed(fontSize: 13, fontColor: .lightGray)
        self.imageNode.url = track.smallTrackCover
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageSize = constrainedSize.max.width * 0.2
        self.imageNode.cornerRadius = 3
        self.imageNode.style.preferredSize = CGSize(width: imageSize * 0.5, height: imageSize * 0.5)
        
        self.actionButton.style.preferredSize = CGSize(width: imageSize * 0.35, height: imageSize * 0.5)
        
        let infoStack = ASStackLayoutSpec.vertical()
        infoStack.style.flexShrink = 1.0
        infoStack.children = [self.titleNode, self.subTitleNode, self.descriptionNode]
        
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let children: [ASLayoutElement] = [
            self.imageNode,
            infoStack,
            spacer,
            self.actionButton
        ]
        
        let horizontalStack = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 8,
                                                justifyContent: .center,
                                                alignItems: .start,
                                                children: children)
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), child: horizontalStack)
    }
    
    @objc private func onOptions() {
        
        self.delegate?
            .onSelected?(object: self.historyEntity.song)
    }
}
