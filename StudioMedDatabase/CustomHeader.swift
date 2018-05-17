//
//  CustomHeader.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
class CustomHeader: UITableViewHeaderFooterView {
    static let reuseIdentifer = "CustomHeaderReuseIdentifier"
    let customLabel = UILabel.init()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        customLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(customLabel)
        
        let margins = contentView.layoutMarginsGuide
        customLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        customLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        customLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        customLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
