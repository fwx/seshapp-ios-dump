//
//  TourHeaderView.swift
//  SeshRadio
//
//  Created by spooky on 9/5/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TourHeaderView: UITableViewHeaderFooterView {
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .lightGray
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 22.5
        
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "test"
        label.textColor = UIColor.white
        
        return label
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        let rootView = self.contentView
        
        rootView.backgroundColor = .navBarTint
        
        rootView.addSubview(self.imageView)
        rootView.addSubview(self.label)
        rootView.addSubview(self.separatorView)
        
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalTo(rootView.snp.top).offset(4)
            make.height.equalTo(45)
            make.width.equalTo(45)
            make.centerX.equalTo(rootView.snp.centerX)
        }
        
        self.label.snp.makeConstraints { [weak self] (make) in
            guard let self = self else { return }
            
            make.top.equalTo(self.imageView.snp.bottom).offset(8)
            make.centerX.equalTo(rootView.snp.centerX)
        }
        
        self.separatorView.snp.makeConstraints { (make) in
            make.left.equalTo(rootView.snp.left)
            make.right.equalTo(rootView.snp.right)
            make.bottom.equalTo(rootView.snp.bottom)
            make.height.equalTo(UIView.defaultOnePixelConversion)
        }
    }
}
