//
//  TeamLinkViewCell.swift
//  SeshRadio
//
//  Created by spooky on 1/7/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit

class TeamLinkViewCell: UITableViewCell {
    @IBOutlet var linkType: UILabel!
    
    
    func setLink(_ link: Link) {
        self.linkType.text = link.getType()
    }
    
}
