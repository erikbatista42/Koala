//
//  MainCVCell.swift
//  Koala
//
//  Created by Erik on 7/31/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit

class UserProfileVideoCell: UICollectionViewCell {
    
    var thumbnail: Post? {
        didSet {
            guard let thumbnailUrl = thumbnail?.thumbnailUrl else { return }
            thumbNailImageView.loadImage(UrlString: thumbnailUrl)
        }
    }
    
    let thumbNailImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = UIColor.clear
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(thumbNailImageView)
        thumbNailImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
