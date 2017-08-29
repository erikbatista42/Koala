//
//  UserSearchCVCell.swift
//  Koala
//
//  Created by Erik Batista on 8/28/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//
import UIKit

class UserSearchCVCell: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .orange
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        return iv
    }()
    
    let usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .brown
        
        subViewsAndCustomizations()
    }
    
    func subViewsAndCustomizations() {
        self.addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        self.addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        let seperatorView = UIView()
        addSubview(seperatorView)
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        seperatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
