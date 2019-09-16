//
//  MLFeaturedHeaderNode.swift
//  SeshRadio
//
//  Created by spooky on 2/23/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SDWebImage
import SkeletonView

class MLFeaturedHaderNode: ASDisplayNode {
    
    init(height: CGFloat = 125, featured: Featured?) {
        super.init()
        
        self.setViewBlock { () -> UIView in
            let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: height))
            //mainView.translatesAutoresizingMaskIntoConstraints = false
            mainView.backgroundColor = .navBarTint
            
            // Cover image
            let imageView = UIImageView(image: #imageLiteral(resourceName: "512x512.png"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .gray
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.isSkeletonable = true
            imageView.showGradientSkeleton()
            imageView.sd_setImage(with: featured?.smallPictureUrl,
                                  completed: { (_, _, _, _) in
              imageView.hideSkeleton()
            })
            
            let titleLabel = UILabel()
            titleLabel.text = featured?.title
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.numberOfLines = 1
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.textColor = .white
            
            let descLabel = UILabel()
            descLabel.text = featured?.subTitle
            descLabel.translatesAutoresizingMaskIntoConstraints = false
            descLabel.numberOfLines = 2
            descLabel.textColor = .lightGray
            
            let downloadButton = UIButton()
            downloadButton.setTitle("", for: .normal)
            downloadButton.translatesAutoresizingMaskIntoConstraints = false
            downloadButton.isHidden = true
            
            mainView.addSubview(titleLabel)
            mainView.addSubview(descLabel)
            mainView.addSubview(imageView)
            mainView.addSubview(downloadButton)
            
            NSLayoutConstraint.activate([
                // Cover image
                imageView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),
                imageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
                imageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16),
                NSLayoutConstraint(item: imageView,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: imageView,
                                   attribute: .height,
                                   multiplier: 1,
                                   constant: 0),
                // Title
                titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
                titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16),
                titleLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16),
//                titleLabel.heightAnchor.constraint(equalToConstant: 42),
                // Description
                descLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16),
                descLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16),
                descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                // Download button
                downloadButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 5),
                downloadButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16)
                
                ])
            
            // will it work?
            return mainView
        }
        
        self.style.height = .init(unit: .points, value: height)
        self.backgroundColor = .darkGray
        
    }
}

class MLFeaturedHeaderHolder: ASDisplayNode {
    var featuredView: UIView? {
        return self.featuredNode.view
    }
    
    let featuredNode: MLFeaturedHaderNode
    
    init(height: CGFloat = 125, featured: Featured?) {
        self.featuredNode = .init(height: height, featured: featured)
        super.init()
        
        self.automaticallyManagesSubnodes = true
        
        self.backgroundColor = .blue
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: self.featuredNode)
    }
}
