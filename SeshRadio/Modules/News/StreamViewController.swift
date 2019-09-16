//
//  StreamViewController.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import UIKit
import AVKit

class StreamViewController: AVPlayerViewController {

    fileprivate var stream: News!
    func setStreamData(stream: News) {
        self.stream = stream
    }
    
    fileprivate var streamAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.streamAdded {
            self.streamAdded = true
            self.createPlayer()
        }
    }
    
    func createPlayer() {
        guard let link = self.stream.linkUrl else {
            // invalid link
            print("INVALID LINK")
            return
        }
        
        self.player = AVPlayer(url: link)
    }
}
