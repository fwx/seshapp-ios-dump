//
//  MLPTrackCell.swift
//  SeshRadio
//
//  Created by spooky on 4/15/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class MLPTrackCell: UITableViewCell {
    
    @IBOutlet var trackCover: UIImageView!
    
    @IBOutlet var trackTitle: UILabel!
    @IBOutlet var trackArtist: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.trackTitle.textColor = selected ? .red : .black
    }
    
    func setTrack(_ track: Track) {
        self.trackTitle.text = track.title
        self.trackArtist.text = track.artistsConcacted
        
        self.trackCover.sd_setImage(with: track.trackCover, completed: nil)
    }
}
