//
//  ExploreVideoPlayer.swift
//  Story Time
//
//  Created by Erik Batista on 4/27/18.
//  Copyright © 2018 swift.lang.eu. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class ExploreVideoPlayer: UIViewController, GetUserFromHomeControllerCellDelegate {

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
    
    lazy var shareButton: UIButton = {
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
        
//
//        // set up activity view controller
//        let textToShare = ["Check out this story I found in storytime: \(videoURL)" ]
//        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//        // exclude some activity types from the list (optional)
//        //        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
//
//        // present the view controller
//        self.present(activityViewController, animated: true, completion: nil)
        
        let activityViewController = UIAlertController()
        
        let flagButton = UIAlertAction(title: "Flag 🚩", style: .destructive) { (action) in
            let alertController = UIAlertController(title: "This post has been Flagged!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        let reportButton = UIAlertAction(title: "Report ⚠️", style: .destructive) { (action) in
            let alertController = UIAlertController(title: "This post has been Reported!", message: "We will review this post and will update you within under 24 hours", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        let  shareButton = UIAlertAction(title: "Share 👥", style: .default, handler: { (action) -> Void in
            let textToShare = ["Check out this story I found in storytime: \(self.videoURL)"]
            let shareActivityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            // exclude some activity types from the list (optional)
            //        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            self.present(shareActivityViewController, animated: true, completion: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        activityViewController.addAction(flagButton)
        activityViewController.addAction(reportButton)
        activityViewController.addAction(shareButton)
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
        
        userProfileController.userId = UserSearchController.didSelectPostUid
        
        self.navigationController?.pushViewController(userProfileController, animated: true)
        userProfileController.rightBarButtonIsHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    func getUser(username: String, profileImage: String, postURL: String) {
        guard let profileImageUrl = UserSearchController.didSelectPostProfileImageURL else { return }
        userProfileImageView.loadImage(UrlString: profileImageUrl)
        
        profileImageButton.setBackgroundImage(userProfileImageView.image, for: .normal)
        videoURL = "\(UserSearchController.didSelectPostVideoURL)"
    } 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        playerLayer = AVPlayerLayer(player: player)
        view.addSubview(videoView)
        
        self.view.layer.addSublayer(playerLayer)
        view.addSubview(shareButton)
        view.addSubview(profileImageButton)
        playerLayer.frame = view.bounds
        player!.play()
        
        shareButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -100, paddingRight: 18, width: 50, height: 50)
        
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

