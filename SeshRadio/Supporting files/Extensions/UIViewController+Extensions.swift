//
//  UIViewController+Extensions.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func createNavBarPlaceholder(_ rootView: UIView) -> UIView {
        let placeholderView = UIView(frame: CGRect.zero)
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.backgroundColor = .navBar
        placeholderView.isUserInteractionEnabled = true
        
        
        placeholderView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(self.unhideBarOnTap)))
        
        rootView.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
                placeholderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                placeholderView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
                placeholderView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
                placeholderView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height * 0.05)
            ])
        
        return placeholderView
    }
    
    @objc func unhideBarOnTap() {
        guard let navigationController = self.navigationController else { return }
        
        navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    func createGradientBackground(for view: UIView) -> UIView {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = UIColor.gradientColors
        gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.frame = view.bounds
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        return backgroundView
    }
    
    var commonNavigation: CommonNavigationViewController? {
        get {
            return self.tabBarController as? CommonNavigationViewController
        }
    }
}


extension UIViewController {
    private struct AssociatedKeys {
        static var searchController = "seshapp.searchController"
    }
    
    var aa_searchController: UISearchController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.searchController) as? UISearchController
        }
        set (manager) {
            objc_setAssociatedObject(self, &AssociatedKeys.searchController, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func aa_createSearchBar() {
        if #available(iOS 11, *) {
            self.aa_searchBar_IOS11()
        } else {
            self.aa_searchBar_IOS10()
        }
        
        self.aa_searchController!.dimsBackgroundDuringPresentation = true
        self.aa_searchController!.searchBar.tintColor = UIColor.lightText
    }
    
    @available(iOS 11, *)
    func aa_searchBar_IOS11() {
        let searchResultController = MLSearchViewController()
        searchResultController.setParent(self)
        searchResultController.setSearchType(.tracks)
        
        self.aa_searchController = UISearchController(searchResultsController: searchResultController)
        self.aa_searchController!.searchResultsUpdater = searchResultController
        self.aa_searchController!.searchBar.delegate = searchResultController
        
        
        self.definesPresentationContext = true
        self.navigationItem.searchController = self.aa_searchController
    }
    
    func aa_searchBar_IOS10() {
        self.aa_searchController!.searchBar.showsScopeBar = true
        //self.tableView.tableHeaderView = self.searchController.searchBar
    }
}
