//
//  ToursViewController.swift
//  SeshRadio
//
//  Created by spooky on 9/5/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import PanModal
import SwiftDate

class ToursViewController: UITableViewController {
    @IBOutlet var footerView: UIView!
    
    var tour: Tour!

    private let headerViewIdentifier = "TourHeaderView"
    private let cellIdentifier = "EventCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .navBarTint
        self.tableView.separatorStyle = .none
        self.footerView.backgroundColor = .navBarTint
        
        self
            .tableView
            .register(TourHeaderView.self,
                      forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        
        
 
    }
    
    @IBAction func onTourOpen(_ sender: Any) {
        guard let url = self.tour.linkUrl else { return }
        
        Utils.openInternal(url, controller: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? TourHeaderView else {
            fatalError()
        }
        
        view.imageView.sd_setImage(with: self.tour.smallImageUrl, completed: nil)
        view.label.text = self.tour.name
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let event = self.tour.events[indexPath.row]
        
        cell.textLabel!.text = event.place
        cell.detailTextLabel!.text = event
            .date
            .toDate("YYYY-MM-dd", region: Region.UTC)!.toFormat("dd MMM 2019")
        cell.backgroundColor = .navBarTint
        cell.detailTextLabel?.textColor = UIColor.lightText
        
        cell.selectionStyle = .gray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tour.events.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.tour.events[indexPath.row]
        
        guard let url = event.linkUrl else { return }
        
        Utils.openInternal(url, controller: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ToursViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return self.tableView
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
}
