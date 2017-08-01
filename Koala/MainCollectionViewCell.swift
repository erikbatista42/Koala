//
//  MainCVCell.swift
//  Koala
//
//  Created by Erik on 7/31/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {
    
    
    
    let thumbNailImageView: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.backgroundColor = UIColor.gray
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.contentMode = UIViewContentMode.scaleAspectFill
        thumbnail.layer.masksToBounds = true
        return thumbnail
    }()
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
//        if !UIAccessibilityIsReduceTransparencyEnabled() {
//            thumbNailImageView.backgroundColor = UIColor.clear
//            
//            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            //always fill the view
//            blurEffectView.frame = thumbNailImageView.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            
//            thumbNailImageView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
//        } else {
//            thumbNailImageView.backgroundColor = UIColor.black
//        }
        let imageURL = URL(string: "http://wallpapercave.com/wp/fRYYDpF.jpg")
        thumbNailImageView.kf.setImage(with: imageURL)
        self.addSubview(thumbNailImageView)
        thumbNailImageView.anchor(top: thumbNailImageView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 124.5, height: 175)
        
    }
}
