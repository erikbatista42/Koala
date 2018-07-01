//
//  UserProfileVideoPlayer.swift
//  Story Time
//
//  Created by Erik Batista on 6/29/18.
//  Copyright © 2018 swift.lang.eu. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class UserProfileVideoPlayer: UIViewController, GetUserFromHomeControllerCellDelegate {
    
    var hc: HomeController!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    let videoView: UIView = {
        let vidView = UIView()
        return vidView
    }()
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .magenta
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        //        button.layer.borderColor = UIColor.white.cgColor
        //        button.layer.borderWidth = 1
        //        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setBackgroundImage(#imageLiteral(resourceName: "share_icon_circled"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleOptionsButton), for: .touchUpInside)
        return button
    }()
    
    var videoURL: String!
    
    @objc func handleOptionsButton() {
        
//        let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .ActionSheet)
        
        let activityViewController = UIAlertController()
        
        let  shareButton = UIAlertAction(title: "Share 👥", style: .destructive, handler: { (action) -> Void in
            let textToShare = ["Check out this story I found in storytime: \(self.videoURL)"]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            // exclude some activity types from the list (optional)
            //        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        })
        
        let  deleteButton = UIAlertAction(title: "Delete 🗑", style: .destructive, handler: { (action) -> Void in
            print("report button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        activityViewController.addAction(shareButton)
         activityViewController.addAction(deleteButton)
        activityViewController.addAction(cancelButton)
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    lazy var profileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setImage(userProfileImageView.image, for: .normal)
        button.addTarget(self, action: #selector(handleProfileImageButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleProfileImageButton() {
        
        let userProfileController = UserProfileController(nibName:nil, bundle:nil)
        
        userProfileController.userId = HomeController.didSelectPostUid
        //        userProfileController.userId = UserSearchController.didSelectPostUid)
        self.navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
    }
    
    func getUser(username: String, profileImage: String, postURL: String) {
        guard let profileImageUrl = HomeController.didSelectPostProfileImageURL else { return }
        userProfileImageView.loadImage(UrlString: profileImageUrl)
        
        profileImageButton.setBackgroundImage(userProfileImageView.image, for: .normal)
        videoURL = "\(HomeController.didSelectPostVideoURL)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        playerLayer = AVPlayerLayer(player: player)
        view.addSubview(videoView)
        
        self.view.layer.addSublayer(playerLayer)
        view.addSubview(optionsButton)
        view.addSubview(profileImageButton)
        playerLayer.frame = view.bounds
        player!.play()
        
        optionsButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -100, paddingRight: 18, width: 50, height: 50)
        
        profileImageButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -35, paddingRight: 18, width: 50, height: 50)
        
        // Make repeat when it reaches the end
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.player?.seek(to: kCMTimeZero)
            self.player?.play()
        }
        
        let callGetUserFunction = "call"
        getUser(username: callGetUserFunction, profileImage: callGetUserFunction, postURL: callGetUserFunction)
        
        UserSearchController.staticSearchBar?.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player!.pause()
        //        player = nil
        playerLayer.removeFromSuperlayer()
    }
    
}

