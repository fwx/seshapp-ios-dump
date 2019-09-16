//
//  FeedCategoryCell.swift
//  SeshRadio
//
//  Created by spooky on 9/5/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

class FeedCategoryCell: UICollectionViewCell {
    
    @IBOutlet var catLabel: UILabel!
}

extension FeedCategoryCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? String else { return }
        
        self.catLabel.text = viewModel
    }
}
