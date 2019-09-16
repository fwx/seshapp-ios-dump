//
//  MemberViewCell.swift
//  SeshRadio
//
//  Created by spooky on 12/16/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import UIKit
import IGListKit
import SDWebImage

private let linkReuseIdentifier = "TeamLinkViewCell"

class MemberViewCell: UITableViewCell {
    @IBOutlet var memberNickname: UILabel!
    @IBOutlet var memberLinksView: UITableView!
    @IBOutlet var memberImage: UIImageView!
    
    @IBOutlet var memberLinksViewHeight: NSLayoutConstraint!
    
    private var member: Member?
    var delegate: PrimitiveSelection?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.memberLinksView.register(UINib(nibName: linkReuseIdentifier, bundle: nil),
                                      forCellReuseIdentifier: linkReuseIdentifier)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

extension MemberViewCell {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? Member else { return }
        self.memberLinksView.dataSource = self
        self.memberLinksView.delegate = self
        self.member = viewModel
        self.memberNickname.text = viewModel.name
        
        self.memberLinksView.reloadData()
        
        self.memberImage.sd_setImage(with: viewModel.avatarUrl, completed: nil)
    }
}

extension MemberViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.member?.links.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: linkReuseIdentifier) as? TeamLinkViewCell
            else { fatalError() }
        
        let link = self.member!.links[indexPath.row]
        cell.setLink(link)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = self.member!.links[indexPath.row]
        
        self.delegate?.onSelected?(object: link)
    }
}
