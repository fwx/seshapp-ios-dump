//
//  NewsViewController.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit
import SafariServices

fileprivate let kStreamSegue = "Stream"
fileprivate let kPaidStreamSegue = "Not supported"



class NewsViewController: UICollectionViewController {
    
    private let disposeBag = DisposeBag()
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    private var models: [ListDiffable] = []
    private var selectedNews: News!
    
    // Pagination
    private var offset = 0
    private var loadingState: LoadingState = .loading
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = .navBarTint
        
        self.setupIGListKit()
        
        self.fetchTours() // Initial fetch
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.followScrollView(self.collectionView, delay: 50)
//            navigationController.shouldUpdateContentInset = false
//            navigationController.navigationBar.barTintColor = .navBar
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
       
    }
    
    func setupIGListKit() {
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
    }
    
    private func fetchTours() {
        self.loadingState = .loading
        
        ShowsService
            .fetchShows()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (result) in
                guard let self = self else { return }
                
                if result.results.count > 0 {
                    self.models.append(FeedString("Tours"))
                    self.models.append(FeedTours(tours: result.results))
                }
                
                
                self.loadingState = .loaded
                
                self.fetchNews()
            }) { [weak self] (error) in
                guard let self = self else { return }
                print(error)
        }.disposed(by: self.disposeBag)
    }
    
    func fetchNews() {
        self.loadingState = .loading
        
        // Fetch
        NewsService
            .fetchNews(offset: self.offset)
            .subscribe(onSuccess: { [weak self] (news) in
                guard let self = self else { return }
                
                if self.offset == 0 {
                    self.models.append(FeedString("News"))
                }
                
                let news = news.results
                // Append news
                self.models.append(contentsOf: news)
                self.offset += news.count
                // Set loading state
                self.loadingState = .loaded
                
                
                self.adapter.performUpdates(animated: true, completion: nil)
                print("kek")
            }) { (error) in
                print(error)
            }.disposed(by: self.disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? StreamViewController {
            dest.setStreamData(stream: self.selectedNews)
        }
    }
}

extension NewsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.models
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is News {
            let controller = IGLNewsSectionController()
            controller.shareDelegate = self
            controller.selectionDelegate = self
            return controller
        }
        
        if object is FeedString {
            let controller = IGLStringSectionController()
            
            return controller
        }
        
        if object is FeedTours {
            let controller = IGLToursSectionController()
            controller.shareDelegate = self
            controller.selectionDelegate = self
            
            return controller
        }
        
        fatalError()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension NewsViewController {
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        
        if self.loadingState != .loading && distance < 200 {
            self.fetchNews()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.loadingState != .loading && scrollView.contentOffset.y < 0 {
            // refresh control
        }
    }
    
}


extension NewsViewController: PrimitiveSelection, ShareProtocol {
    // User wants to share the news
    func onShare(object: Any) {
        guard let news = object as? News else { return }
        
        if news.tags.contains("paid") { print("!!! NOT IMPLEMENTED !!!"); return }
        
        guard let link = news.linkUrl else { return }
        
        let shareText = String(format: "%@\r\n%@",
                               news.text,
                               news.category == .stream ? Globals.Strings.WATCH_STREAM : link.absoluteString) // ToDO: Open in app
        
        Utils.shareData([shareText], controller: self)
    }
    
    // Did tap on news
    func onSelected(object: Any?) {
        if object is News {
            guard let news = object as? News else { return }
            guard let category = news.category else { return }
            
            FeedBackGenerator.shared.impact(style: .light)
            
            if category == .release || category == .stream {
                guard let url = news.linkUrl else { return }
                
                if category == .stream {
                    if news.tags.contains("paid") {
                        self.performSegue(withIdentifier: kPaidStreamSegue, sender: nil)
                        return
                    }
                    
                    self.selectedNews = news
                    self.performSegue(withIdentifier: kStreamSegue, sender: nil)
                    return
                } else if category == .release {
                    
                    //UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    Utils.openInternal(url, controller: self)
                }
            } else if category == .tour {
                // open in app?
                // share tour via shows screen
                print("T O U R  @ READ COMMENT")
            }
        } else if object is Tour {
            guard let tour = object as? Tour else { return }
            
            guard let controller = UIStoryboard(name: "Shows", bundle: nil).instantiateViewController(withIdentifier: "ToursViewController") as? ToursViewController else {
                return
            }
            
            controller.tour = tour
            
            self.presentPanModal(controller)
        }
        
        
       
        
    }
}

