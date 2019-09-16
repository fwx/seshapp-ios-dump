//
//  SearchTrackCell.swift
//  SeshRadio
//
//  Created by spooky on 1/9/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import SDWebImage
import AsyncDisplayKit

class SearchTrackNode: ASCellNode {
    
    private var track: Track!
    private var album: Album!
    private var artist: Artist!
    
    private var type: SearchResultType = .song
    
    private let titleNode = ASTextNode()
    private let subTitleNode = ASTextNode()
    private let descriptionNode = ASTextNode()
    private let imageNode = ASNetworkImageNode()
    
    private var fontScale: CGFloat = 1
    
   // private let containerNode: ContainerNode
    /*
     * [ IMAGE ]
     */
    
    init(type: SearchResultType, data: Any) {
        self.type = type
        
        if type == .album || type == .member {
            self.fontScale = 1
        } else {
            self.fontScale = 0.9
        }
        
        switch type {
        case .album:
            self.album = data as? Album
        case .member:
            self.artist = data as? Artist
        case .song:
            self.track = data as? Track
        default:
            fatalError()
        }
        
        super.init()
        
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
        
        self.createNodes()
    }
    
    
    func createNodes() {
        self.imageNode.contentMode = .scaleToFill
        
        self.titleNode.truncationMode = .byTruncatingTail
        
        // Album or track have kinda same appereance
        if self.type == .album || self.type == .song {
            self.titleNode.maximumNumberOfLines = 1
            
            var title = ""
            var subtitle = ""
            var description = ""
            var imageUrl: URL?
            
            if self.type == .album {
                title = "album" + " • " + self.album.title
                subtitle = self.album.artistsConcated
                description = String(self.album.year)
                imageUrl = self.album.smallAlbumCover
            } else {
                title = self.track.title
                subtitle = self.track.artistsConcacted
                description = String(format: "%@ • %@", self.track.albumTitle, "\(self.track.trackYear)")
                imageUrl = self.track.smallTrackCover
            }
            
            self.titleNode.attributedText = title.createAttributed(fontSize: 16 * self.fontScale, fontColor: .white)
            self.subTitleNode.attributedText = subtitle.createAttributed(fontSize: 14 * self.fontScale, fontColor: .lightGray)
            self.descriptionNode.attributedText = description.createAttributed(fontSize: 13 * self.fontScale, fontColor: .lightGray)
            self.imageNode.url = imageUrl
        } else {
            // Artist only
            self.subTitleNode.attributedText = self.artist.name.createAttributed(fontSize: 16 * self.fontScale, fontColor: .white)
            self.imageNode.url = self.artist.smallAvatarUrl
        }
        
       
       
        
        
        
    }
    
    override func didLoad() {
        super.didLoad()
        
        self.layer.borderColor = UIColor.darkText.withAlphaComponent(0.2).cgColor
        self.layer.borderWidth = 0.5
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageSize = constrainedSize.max.width * 0.17
        
        self.imageNode.style.preferredSize = CGSize(width: imageSize, height: imageSize)
        
        
        if self.type == .member {
            self.imageNode.cornerRadius = self.imageNode.style.preferredSize.height / 2
        } else {
            self.imageNode.cornerRadius = 3
        }
        
        // [ Title ]
        // [ Artist ]
        // [ Description ]
        let infoStack = ASStackLayoutSpec.vertical()
        infoStack.style.flexShrink = 1.0
        if self.type == .album || self.type == .song {
            infoStack.children = [self.titleNode, self.subTitleNode, self.descriptionNode]
            
        } else {
            infoStack.children = [self.subTitleNode]
        }
       
        
        // [Image], [InfoStack]
        let horizontalStack = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 8,
                                                justifyContent: .start,
                                                alignItems: .center,
                                                children: [self.imageNode, infoStack])
        
        horizontalStack.style.flexShrink = 1.0
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), child: horizontalStack)
    }

}

//class ContainerNode: ASDisplayNode {
//    override func didLoad() {
//        super.didLoad()
//
//        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(1).cgColor
//        self.layer.borderWidth = 1.0
//    }
//}
