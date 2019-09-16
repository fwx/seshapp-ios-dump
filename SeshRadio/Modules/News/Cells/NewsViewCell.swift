//
//  NewsViewCell.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import UIKit
import IGListKit
import SDWebImage

class NewsViewCell: UICollectionViewCell {
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var newsDesc: UILabel!
    @IBOutlet var newsDate: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var newsImage: UIImageView!
    @IBOutlet var holderView: UIView!
    @IBOutlet var overlayView: UIView!
    
    private var shareDelegate: ShareProtocol?
    func setShareDelegate(_ delegate: ShareProtocol) { self.shareDelegate = delegate }
    
    private var news: News!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.newsImage.contentMode = .scaleAspectFill
        self.newsImage.clipsToBounds = true
    }
    
    @IBAction func onShareBtn(_ sender: Any) {
        print("S H A R E")
        self.shareDelegate?.onShare?(object: self.news)
    }
}


extension NewsViewCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? News else { return }
        self.news = viewModel
        
        self.fillData(news: viewModel)
        self.newsImage.round(cornerRadius: 10)
        self.overlayView.round(cornerRadius: 10)
    }
    
    func fillData(news: News) {
        self.newsTitle.text = news.title
        self.newsDesc.text = news.text.uppercased()
        self.newsDate.text = news.changedDate?.toFormat("dd MMM YY - HH:mm")
        
        guard let category = news.category else {
            self.icon.alpha = 0
            return
        }
        if category == .release {
            self.icon.alpha = 0
        } else {
            self.icon.alpha = 1
            if category == .tour {
                self.icon.image = #imageLiteral(resourceName: "ic_news_tour.png")
            }
            if category == .stream {
                self.icon.image = #imageLiteral(resourceName: "ic_news_live.png")
            }
        }
        
        
        guard let imageUrl = news.imageUrl else {
            self.newsImage.image = #imageLiteral(resourceName: "512x512.png")
            return
        }
        
        self.newsImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //self.newsImage.sd_setShowActivityIndicatorView(true)
        self.newsImage.sd_setImage(with: imageUrl, completed: nil)
    }
}
