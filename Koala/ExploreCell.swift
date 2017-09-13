//
//  ExploreCell.swift
//  Koala
//
//  Created by Erik Batista on 9/6/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    
    var thumbnail: Post? {
        didSet {
            guard let thumbnailUrl = thumbnail?.thumbnailUrl else { return }
            thumbNailImageView.loadImage(UrlString: thumbnailUrl)
        }
    }
    
    var post: Post? {
        didSet {
            guard let thumbnailUrl = post?.thumbnailUrl else { return }
            thumbNailImageView.loadImage(UrlString: thumbnailUrl)
            
//            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "heart_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "heart_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
//            
            //            usernameLabel.text = "\(post?.user.username ?? "")\n\(timeLabel.attributedText?.string ?? "")"
//            usernameLabel.text  = post?.user.username
            
//            guard let profileImageUrl = post?.user.profileImageUrl else { return }
//            userProfileImageView.loadImage(UrlString: profileImageUrl)
//            setupTimeLabel()
        }
    }
    
    let thumbNailImageView: CustomImageView = {
        let iv = CustomImageView()
//        iv.backgroundColor = UIColor.gray
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
