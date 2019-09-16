//
//  MusicLibraryArtistsViewController.swift
//  SeshRadio
//
//  Created by spooky on 1/10/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit
import RxSwift
import FSPagerView

fileprivate protocol Section {
    var title: String! { get set }
    var data: [Any] { get set }
}

fileprivate class AlbumsSection: Section {
    var data: [Any] = []
    var title: String! = "Albums"
    
    required init(data: [Any] = []) {
        self.data = data
    }
}

fileprivate class TracksSection: Section {
    var title: String! = "Tracks"
    var data: [Any] = []
    
    required init(data: [Any] = []) {
        self.data = data
    }
}

protocol ArtistDataSelection: class {
    func onSelected(_ type: Globals.MLSearchType)
}

fileprivate class HeaderView: UITableViewHeaderFooterView {
    lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "kektop"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-SemiBold", size: 19)
        label.textColor = .white
        
        return label
    }()
    
    lazy var showAllBtn: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show all", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 19)
        button.setTitleColor(.lightGray, for: .normal)
        
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.title)
        self.addSubview(self.showAllBtn)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            showAllBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            showAllBtn.centerYAnchor.constraint(equalTo: title.centerYAnchor, constant: 0)
            ])
        
        self.contentView.backgroundColor = .clear
        
        self.showAllBtn
            .addTarget(self,
                       action: #selector(self.onButtonPressed(_:)),
                       for: .touchUpInside)
    }
    
    @objc func onButtonPressed(_ sender: Any) {
        self.delegate?.onSelected(self.type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var type: Globals.MLSearchType!
    weak var delegate: ArtistDataSelection?
}

class MLArtistViewController: ASViewController<ASTableNode> {
    
    let tableNode = ASTableNode()
    
    var artist: Artist! {
        didSet {
            self.title = artist.name
            self.fetchData()
        }
    }
    private var disposeBag: DisposeBag! = DisposeBag()
    private var loadingState: LoadingState = .loading
    
    private var sections: [Section] = []
    private var albums: [Album] = []
    
    
    init() {
        super.init(node: self.tableNode)
        
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.keyboardDismissMode = .onDrag
        
        
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.backgroundColor = .navBar
        
        self.tableNode.view.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }
    
    deinit {
        self.disposeBag = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchData() {
        guard self.artist != nil else { return }
        
        let albums = AlbumsService
            .fetchAlbums(search: self.artist.name,
                         limit: 20,
                         offset: 0)
        
        
        let songs = MusicService.fetchTracks(search: self.artist.name,
                                 limit: 7,
                                 offset: 0)
        Single
            .zip(albums, songs)
            .subscribe(onSuccess: { [weak self] (albums, tracks) in
                guard let self = self else { return }
                
                let albums = albums.results
                let tracks = tracks.results
                if tracks.count > 0 {
                    self.sections.append(TracksSection(data: tracks))
                }
                if albums.count > 0 {
                    self.sections.append(AlbumsSection(data: []))
                    self.albums = albums
                }
                self.tableNode.reloadData()
            }) { (error) in
                print(error)
        }.disposed(by: self.disposeBag)
    }
    
    
}

extension MLArtistViewController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.sections.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        if section is AlbumsSection { return 1 }
        else {
            return section.data.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        let section = self.sections[section]
        
        view.title.text = section.title
        view.delegate = self
        
        if section is AlbumsSection {
            view.type = .albums
        } else if section is TracksSection {
            view.type = .tracks
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let section = self.sections[indexPath.section]
        
        if section is AlbumsSection {
            let albumBlock = { () -> ASCellNode in
                let node = MLArtistAlbumHolder(dataSource: self, delegate: self)
                return node
            }
            
            return albumBlock
        } else if section is TracksSection {
            let object = section.data[indexPath.row]

            let trackBLock = { () -> ASCellNode in
                let node = MusicLibraryViewNode(type: .tracks, data: object as! Track)
                node.delegate = self
                return node
            }

            return trackBLock
            
  
        }
        
        return { ASCellNode() }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let section = self.sections[indexPath.section]
        guard section is TracksSection else { return }
        
        Utils.updatePlayer(allTracks: section.data as! [Track],
                           index: indexPath.row,
                           commonNavigation: self.commonNavigation)
    }
}


extension MLArtistViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.albums.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: kAlbumCellIdentifier, at: index) as! AlbumViewCell
        let album = self.albums[index]
        
        cell.setAlbum(album)
        
        return cell
    }
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let album = self.albums[index]
        
        let controller = MLTracksViewerController()
        controller.setDataType(.albums)
        controller.setAlbum(album)
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}


extension MLArtistViewController: PrimitiveSelection, ArtistDataSelection {
    func onSelected(object: Any?) {
        if object is Track {
            Utils.displayOptions(for: object as! Track, controller: self)
        }
    }
    
    func onSelected(_ type: Globals.MLSearchType) {
        print("type: \(type)")
        
        if type == .tracks {
            let controller = MLTracksViewerController()
            controller.setDataType(.artists)
            controller.setArtist(self.artist)
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            let controller = MLAlbumsViewController()
            controller.artist = self.artist
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
