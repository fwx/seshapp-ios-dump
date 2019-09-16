//
//  NewsInteractor.swift
//  SeshRadio
//
//  Created by spooky on 1/16/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation


protocol NewsInteractorProtocol {
    func open(url: URL)
    func share(news: News)
    
}
