//
//  MainCVCell.swift
//  Koala
//
//  Created by Erik on 7/31/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    let thumbNailImageView: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.backgroundColor = .magenta
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
//        thumbnail.topAnchor.constraint(equalTo: thumbnail.topAnchor, constant: 0).isActive = true
//        thumbnail.rightAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: 0).isActive = true
//        thumbnail.bottomAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 0).isActive = true
//        thumbnail.leftAnchor.constraint(equalTo: thumbnail.leftAnchor, constant: 0).isActive = true
        
        return thumbnail
    }()
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbNailImageView.image = nil
        self.addSubview(thumbNailImageView)
        thumbNailImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 124.5, height: 175)
        
    }
}
