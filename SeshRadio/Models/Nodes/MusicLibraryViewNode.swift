//
//  MLAlbumViewNode.swift
//  SeshRadio
//
//  Created by spooky on 1/10/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import AsyncDisplayKit

// Common node for displaying tracks or albums
class MusicLibraryViewNode: ASCellNode {
    private var album: Album!
    private var track: Track!
    private var type: Globals.MLSearchType
    
    private let titleNode = ASTextNode()
    private let subTitleNode = ASTextNode()
    private let descriptionNode = ASTextNode()
    private let imageNode = ASNetworkImageNode()
    private let actionButton = ASButtonNode() // todo replace with asimagenode
    
    var delegate: PrimitiveSelection?
    private var hideCover = false
    
    private var scaleFactor: CGFloat = 1

    init(type: Globals.MLSearchType,
         data: Any,
         scaleFactor: CGFloat = 1.0,
         hideCover: Bool = false) {
        
        
        self.scaleFactor = scaleFactor
        self.type = type
        self.hideCover = hideCover
        
        // Assign data
        if type == .albums {
            self.album = data as? Album
        } else if type == .tracks {
            self.track = data as? Track
        }
        
        super.init()
        
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
        
        
        self.createNodes()
    }

    
    func createNodes() {
        var title = ""
        var subtitle = ""
        var description = ""
        var imageUrl: URL?
        
        if self.type == .tracks {
            title = self.track.title
            subtitle = self.track.artistsConcacted
            description = String(format: "%@ • %@", self.track.albumTitle, "\(self.track.trackYear)")
            imageUrl = hideCover ? nil : self.track.smallTrackCover
            actionButton.setTitle("...", with: nil, with: .lightGray, for: .normal)
            actionButton.addTarget(self,
                                   action: #selector(self.onOptions),
                                   forControlEvents: .touchUpInside)
        } else {
            title = self.album.title
            subtitle = self.album.artistsConcated
            description = String(self.album.year)
            imageUrl = hideCover ? nil : self.album.albumCover
            actionButton.setTitle("", with: nil, with: .lightGray, for: .normal)
        }
        
        self.imageNode.contentMode = .scaleToFill
        self.titleNode.maximumNumberOfLines = 1
        
        self.titleNode.attributedText = title
            .createAttributed(fontSize: 16, fontColor: .white)
        self.subTitleNode.attributedText = subtitle
            .createAttributed(fontSize: 14, fontColor: .lightGray)
        self.descriptionNode.attributedText = description
            .createAttributed(fontSize: 13, fontColor: .lightGray)
        self.imageNode.url = imageUrl
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageSize = constrainedSize.max.width * 0.2
        self.imageNode.cornerRadius = 3
        self.imageNode.style.preferredSize = CGSize(width: imageSize * scaleFactor, height: imageSize * scaleFactor)
        
        self.actionButton.style.preferredSize = CGSize(width: (imageSize * 0.35), height: (imageSize) * scaleFactor)
        
        let infoStack = ASStackLayoutSpec.vertical()
        infoStack.style.flexShrink = 1.0
        infoStack.children = [self.titleNode, self.subTitleNode, self.descriptionNode]
        
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        var children: [ASLayoutElement] = [infoStack, spacer, self.actionButton]
        if !self.hideCover {
            children.insert(self.imageNode, at: 0)
        }
        let horizontalStack = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 8,
                                                justifyContent: .center,
                                                alignItems: .start,
                                                children: children)
        
  
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), child: horizontalStack)
    }
    
    @objc private func onOptions() {
        
        self.delegate?
            .onSelected?(object: self.type == .tracks ? self.track : self.album)
    }
}
