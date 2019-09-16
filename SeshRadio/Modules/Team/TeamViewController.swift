//
//  TeamViewController.swift
//  SeshRadio
//
//  Created by spooky on 12/16/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift
import DifferenceKit

fileprivate let kCellIdentifier = "MemberCell"
fileprivate let linkHeight: CGFloat = 50

class TeamData {
    class MemberModel: Differentiable {
        var expanded = false
        var member: Member
        
        init(expanded: Bool = false, member: Member) {
            self.expanded = expanded
            self.member = member
        }
        
        var differenceIdentifier: String {
            return self.member.name
        }
        
        func isContentEqual(to source: TeamData.MemberModel) -> Bool {
            return source.member.links == self.member.links
                && source.member.name == self.member.name
        }
    }
    
}

class TeamViewController: UITableViewController {
    private var members: [TeamData.MemberModel] = []
    
    private var loadingState: LoadingState = .loading
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.fetchMembers()
    }
    
    override func didReceiveMemoryWarning() {
        self.members = []
        self.tableView.reloadData()
        
        super.didReceiveMemoryWarning()
    }

    func fetchMembers() {
        TeamService.fetchMembers(limit: 100)
            .map({ (members) -> [TeamData.MemberModel] in
                return members
                    .results
                    .map({ return TeamData.MemberModel(expanded: false, member: $0) })
            })
            .subscribe(onSuccess: { (mappedMember) in
                let changeset = StagedChangeset(source: self.members, target: mappedMember)
                
                self.loadingState = .loaded
                
                self.tableView.reload(using: changeset, with: .fade, setData: { (data) in
                    self.members = mappedMember
                })
                
            }) { (error) in
                print(error)
            }.disposed(by: self.disposeBag)
    }
 
}

extension TeamViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as? MemberViewCell else { fatalError() }
        let model = self.members[indexPath.row]
        
        cell.bindViewModel(model.member)
        cell.memberLinksView.alpha = model.expanded ? 1 : 0
        cell.memberLinksViewHeight.constant = CGFloat(model.member.links.count) * linkHeight
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getHeight(for: indexPath.row)
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getHeight(for: indexPath.row)
    }
    
    func getHeight(for index: Int) -> CGFloat {
        let model = self.members[index]
        
        return model.expanded ? CGFloat(model.member.links.count + 1) * linkHeight : linkHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.members[indexPath.row].expanded = !self.members[indexPath.row].expanded
        
        FeedBackGenerator.shared.impact(style: .light)
        
        self.tableView.beginUpdates()
        if let cell = tableView.cellForRow(at: indexPath) as? MemberViewCell {
            UIView.animate(withDuration: 0.3) {
                cell.memberLinksView.alpha = self.members[indexPath.row].expanded ? 1 : 0
            }
        }
        
        self.tableView.endUpdates()
        
        
    }
}

extension TeamViewController: PrimitiveSelection {
    func onSelected(object: Any?) {
        guard let object = object as? Link else { return }
        
        Utils.openLink(object.getLink(), controller: self)
    }
}
