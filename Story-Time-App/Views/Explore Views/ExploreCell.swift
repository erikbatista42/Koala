//
//  ExploreCell.swift
//  Koala
//
//  Created by Erik Batista on 9/6/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let thumbnailUrl = post?.thumbnailUrl else { return }
            thumbNailImageView.loadImage(UrlString: thumbnailUrl)
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(UrlString: profileImageUrl)
            setupTimeLabel()
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
    
    let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "blurbg.png")!)
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.white])
        label.attributedText = attributedText
        return label
    }()
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(thumbNailImageView)
        thumbNailImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(blurView)
        blurView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 150, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 150, height: 50)
        
        userProfileImageView.layer.cornerRadius = 30/2
        
        setupBottomCellButtonsAndLabels()
        setupTimeLabel()
    }
    
    func setupTimeLabel() {
        guard let post = self.post else { return }
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        let attributedText = NSMutableAttributedString(string: timeAgoDisplay, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : UIColor.white])
        timeLabel.attributedText = attributedText
    }
    
    fileprivate func setupBottomCellButtonsAndLabels() {
        let timeAndOptionsStackView = UIStackView(arrangedSubviews: [userProfileImageView])
        timeAndOptionsStackView.distribution = .fillEqually
        timeAndOptionsStackView.spacing = 10
        addSubview(timeAndOptionsStackView)
        timeAndOptionsStackView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 25, paddingLeft: 0, paddingBottom: -8, paddingRight: 8, width: 30, height: 30)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 150, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

