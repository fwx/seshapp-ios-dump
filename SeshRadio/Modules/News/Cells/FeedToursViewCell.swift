//
//  FeedToursViewCell.swift
//  SeshRadio
//
//  Created by spooky on 9/3/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import FSPagerView
import IGListKit

fileprivate let cellIdentifier = "TourViewCell"
class FeedToursViewCell: UICollectionViewCell {
    @IBOutlet var pagerView: FSPagerView!
    
    var selectionDelegate: PrimitiveSelection?
    
    var tours: [Tour] = [] {
        didSet {
            self.pagerView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pagerView
            .register(UINib(nibName: cellIdentifier, bundle: nil),
                      forCellWithReuseIdentifier: cellIdentifier)
        
        self.pagerView.backgroundColor = .navBarTint
        self.pagerView.dataSource = self
        self.pagerView.interitemSpacing = 15
        self.pagerView.delegate = self
        self.pagerView.itemSize = CGSize(width: self.bounds.height + 30, height: self.bounds.height)
    }
}

extension FeedToursViewCell: ListBindable {
    private func initPager() {
      
        
    }
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? [Tour] else {
            return
        }
        
        self.initPager()
        
        self.tours = viewModel
        
    }
}

extension FeedToursViewCell: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.tours.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView
            .dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                 at: index) as? TourViewCell else {
                                    fatalError()
        }
        let tour = self.tours[index]
        cell.setTour(tour)
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.selectionDelegate?.onSelected?(object: self.tours[index])
    }
}
