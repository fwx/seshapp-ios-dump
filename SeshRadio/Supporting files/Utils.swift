//
//  Utils.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class Utils {
    static let dateCompsFormatter = DateComponentsFormatter()
    
    static func shareData(_ data: [String], controller: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: data, applicationActivities: nil)
        
        DispatchQueue.main.async {
            controller.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    static func openInternal(_ link: URL, controller: UIViewController) {
        let sfController = SFSafariViewController(url: link)
        sfController.preferredBarTintColor = UIColor.navBar
        
        controller.present(sfController, animated: true, completion: nil)
    }
    
    static func openLink(_ link: URL?, controller: UIViewController?) {
        guard let link = link else { return }
        
        let _openLink = {
            UIApplication.shared.open(link,
                                      options: [:],
                                      completionHandler: nil)
        }
        
        if let controller = controller {
            let alert = UIAlertController(title: "Leaving SESHapp",
                                          message: String(format: "Are you sure want to open '%@'?", link.absoluteString),
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                _openLink()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                controller.present(alert, animated: true, completion: nil)
            }
            
        } else {
             _openLink()
        }
        
    }
    
    static func updatePlayer(allTracks: [Track],
                             index: Int,
                             commonNavigation: CommonNavigationViewController? = nil) {
        
        let track = allTracks[index]
        
        //(track-50...track...track+50)
        let minimum = max(0, index - 50)
        let maximum = min(index + 50, allTracks.count)
        
        // Tracks to remember
        let memory = Array(allTracks[minimum..<maximum])
        
        PlayerHelper.shared.setMemory(tracks: memory)
        PlayerHelper.shared.setTrack(track) // update track
        commonNavigation?.triggerMiniPlayer()
    }
    
    static func displayOptions(for track: Track,
                        controller: UIViewController,
                        delegate: TrackOptionsProtocol? = nil) {
        let options = UIStoryboard(name: "Misc", bundle: nil)
            .instantiateViewController(withIdentifier: "Options") as! MLOptionsViewController
        
        options.track = track
        
        if let delegate = delegate {
            options.delegate = delegate
        }
        
        DispatchQueue.main.async {
            controller.presentPanModal(options)
        }
    }
}
