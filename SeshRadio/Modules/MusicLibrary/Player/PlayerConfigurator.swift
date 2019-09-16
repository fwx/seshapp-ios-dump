//
//  PlayerConfigurator.swift
//  SeshRadio
//
//  Created by spooky on 1/20/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit

class PlayerConfigurator: PlayerConfigurationProtocol {
    func configure(with viewController: MusicLibraryPlayerViewController) {
        let presenter = PlayerPresenter(controller: viewController)
        let interactor = PlayerInteractor(presenter: presenter)
        
        //presenter.configurePager()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        
        //viewController.tracksPager.dataSource = presenter
        
//        viewController.tableView.dataSource = presenter
//        viewController.tableView.delegate = presenter
        
        interactor.createSubscribers()
    }
}
