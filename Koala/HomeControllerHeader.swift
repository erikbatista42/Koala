//
//  HomeControllerHeader.swift
//  Vlogr
//
//  Created by Erik Batista on 1/21/18.
//  Copyright © 2018 kennybatista. All rights reserved.
//

import UIKit
import Firebase

class HomeControllerHeader: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        //        label.text = "@username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 14)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor.rgb(red: 206, green: 12, blue: 36, alpha: 1)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(handleUserProfileButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSearchButton() {
        
    }
    
    lazy var exploreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("explore", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 14)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor.rgb(red: 206, green: 12, blue: 36, alpha: 1)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleExploreButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleExploreButton() {
//        let exploreCollectionView = ExploreCV.self
        
//        (HomeControllerHeader.next as? UIViewController)?.navigationController?.pushViewController(exploreCollectionView, animated: true)
//        let navController = UINavigationController(rootViewController: UserSearchController)
//        (searchUsersCV.next as? UIViewController)?.navigationController?.pushViewController(userProfileController, animated: true)
        
      
//        self.navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(red: 27, green: 52, blue: 100, alpha: 1)
        //        backgroundColor = UIColor.rgb(red: 206, green: 12, blue: 36, alpha: 1) // red
        backgroundColor = .white
        //        backgroundColor = UIColor.rgb(red: 205, green: 212, blue: 221, alpha: 1) // Type of gray
//        addSubview(editProfileFollowButton)
//        editProfileFollowButton.anchor(top: followersLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 220, height: 30)
//        editProfileFollowButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addSubview(searchButton)
        searchButton.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 220, height: 30)
        searchButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(exploreButton)
        exploreButton.anchor(top: searchButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 85, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 220, height: 30)
        exploreButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    fileprivate func setupUserStatsView() {
//        let stackView = UIStackView(arrangedSubviews: [vloggiesLabel,followersLabel,followingLabel])
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.spacing = 15
//        
//        addSubview(stackView)
//        stackView.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 50)
//        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

