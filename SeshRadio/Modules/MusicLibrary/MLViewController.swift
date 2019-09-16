//
//  MusicLibraryViewController.swift
//  SeshRadio
//
//  Created by spooky on 12/18/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import UIKit
import FSPagerView
import RxSwift
import IGListKit
import SkeletonView


let kArtistCellIdentifier = "ArtistViewCell"
let kAlbumCellIdentifier = "AlbumViewCell"
let kFeaturedCellIdentifier = "FeaturedViewCell"


fileprivate let kAlbumsSegue = "AlbumsSegue"
fileprivate let kArtistsSegue = "AlbumsSegue"

fileprivate let tracksCellIdentifier = "TracksViewCell"

class MLViewController: UITableViewController {

    @IBOutlet var featuredPagerView: FSPagerView!
    @IBOutlet var albumsPagerView: FSPagerView!
    @IBOutlet var artistsPagerView: FSPagerView!
    
    private var searchController: UISearchController!
    
    private let disposeBag = DisposeBag()
    
    // Data
    var featured: [Featured] = []
    var artists: [Artist] = []
    var albums: [Album] = []
    var tracks: [Track] = []
    
    private var trackSubject = PublishSubject<[Track]>()
    
    lazy var tracksViewer: MLTracksViewerController = {
       return MLTracksViewerController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create search bar
        //self.createSearchBar()
        //self.tableView.backgroundView = self.createGradientBackground(for: self.tableView)
        self.initFeatured()
        self.initArtists()
        self.initAlbums()
        
        self.fetchData()
    }
    
    @IBAction func onOfflineBtn(_ sender: Any) {
        let controller = MLOfflineViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func fetchData() {
        
        MusicService
            .fetchArtists()
            .map({ (response) -> [Member] in
                return response.results
            })
            .subscribe(onSuccess: { [weak self] (members) in
                guard let self = self else { return }
                
                self.artists = members
                self.artistsPagerView.reloadData()
                
//                if members.count > 0 {
//                    self.artistsPagerView.scrollToItem(at: 1, animated: false)
//                }
            }) { (error) in
                print(error)
        }.disposed(by: self.disposeBag)
        
        AlbumsService
            .fetchAlbums()
            .subscribe(onSuccess: { [weak self] (albums) in
                guard let self = self else { return }
                
                let albums = albums.results
                self.albums = albums
                //self.albumsPagerView.hideSkeleton()
                self.albumsPagerView.reloadData()
            }) { (error) in
                print(error)
            }
        .disposed(by: self.disposeBag)
        
        PlaylistsService
            .fetch()
            .subscribe(onSuccess: { [weak self] (featured) in
                guard let self = self else { return }
                
                self.featured = featured.results
                //self.featuredPagerView.hideSkeleton()
                self.featuredPagerView.reloadData()
            }) { (error) in
                print(error)
            }
            .disposed(by: self.disposeBag)
    }
    
    
    @IBAction func onArtists(_ sender: Any) {
        let controller = MLArtistsViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func onAlbums(_ sender: Any) {
        let controller = MLAlbumsViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onSongs(_ sender: Any) {
        let controller = MLTracksViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// Search Bar
extension MLViewController {
    func createSearchBar() {
        if #available(iOS 11, *) {
            self.searchBar_IOS11()
        } else {
            self.searchBar_IOS10()
        }
        
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.tintColor = UIColor.lightText
    }
    
    @available(iOS 11, *)
    func searchBar_IOS11() {
        let searchResultController = MLSearchViewController()
        searchResultController.setParent(self)
        searchResultController.setSearchType(.tracks)
        
        self.searchController = UISearchController(searchResultsController: searchResultController)
        self.searchController.searchResultsUpdater = searchResultController
        self.searchController.searchBar.delegate = searchResultController
        
        
        self.definesPresentationContext = true
        self.navigationItem.searchController = self.searchController
    }
    
    func searchBar_IOS10() {
        self.searchController.searchBar.showsScopeBar = true
        self.tableView.tableHeaderView = self.searchController.searchBar
    }
}

// Data Source
extension MLViewController {
    func initFeatured() {
        self.featuredPagerView.automaticSlidingInterval = 3.0
        self.featuredPagerView.interitemSpacing = 10
        self.featuredPagerView.dataSource = self
        self.featuredPagerView.delegate = self
        self.featuredPagerView.itemSize = CGSize(width: self.view.frame.width - 50, height: self.featuredPagerView.frame.height)
        self.featuredPagerView.register(UINib(nibName: kFeaturedCellIdentifier,
                                              bundle: nil),
                                        forCellWithReuseIdentifier: kFeaturedCellIdentifier)
    }
    
    func initAlbums() {
        self.albumsPagerView.dataSource = self
        self.albumsPagerView.delegate = self
        self.albumsPagerView.interitemSpacing = 15
        self.albumsPagerView.itemSize = CGSize(width: self.albumsPagerView.frame.height + 30, height: self.albumsPagerView.frame.height)
        self.albumsPagerView.register(UINib(nibName: kAlbumCellIdentifier,
                                            bundle: nil),
                                      forCellWithReuseIdentifier: kAlbumCellIdentifier)
    }
    
    func initArtists() {
        self.artistsPagerView.clipsToBounds = false
        self.artistsPagerView.delegate = self
        self.artistsPagerView.dataSource = self
        self.artistsPagerView.interitemSpacing = 15
        self.artistsPagerView.itemSize = CGSize(width: self.view.frame.width / 2, height: self.albumsPagerView.frame.height)
        
        self.artistsPagerView.register(UINib(nibName: kArtistCellIdentifier,
                                             bundle: nil),
                                       forCellWithReuseIdentifier: kArtistCellIdentifier)
    }
    
}

// Tracks data source
extension MLViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tracksCellIdentifier, for: indexPath) as? TrackViewCell else { fatalError() }
        
        let track = self.tracks[indexPath.row]
        cell.setTrackImage(track.trackCover)
        
        return cell
    }
}

// CollectionViews' selection
extension MLViewController: MusicLibraryProtocol {
    func onDataSelected(_ data: Any) {
        // forgot how to swift generics
        if data is Album {
            
        } else if data is Artist {
            
        } else if data is Track {
            
        }
    }
}
