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

class ExploreVideoPlayerController: UIViewController, GetUserFromHomeControllerCellDelegate {

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
    
    lazy var reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setBackgroundImage(#imageLiteral(resourceName: "report"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleReportButton), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        //        button.layer.borderColor = UIColor.white.cgColor
        //        button.layer.borderWidth = 1
        //        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setBackgroundImage(#imageLiteral(resourceName: "share_icon_circled"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        return button
    }()
    
    var videoURL: String!
    var flaggedOrReportedPostUrl: String!
    
    @objc func handleReportButton() {
        
        let alertController = UIAlertController(title: "Unfavorable content?", message: nil, preferredStyle: .alert)
        let flagAction = UIAlertAction(title: "Flag as inappropriate 🚩", style: .destructive) { (action) in
            let alertController = UIAlertController(title: "This post has been flagged!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            //            videoURL = "\(HomeController.didSelectPostVideoURL)"
            self.flaggedOrReportedPostUrl = "\(HomeController.didSelectPostVideoURL ?? "")"
            print("post flagged: \(self.flaggedOrReportedPostUrl ?? "")")
            
            let values = ["\(Auth.auth().currentUser?.uid ?? "")": "\(self.flaggedOrReportedPostUrl ?? "")"]
            
            Database.database().reference().child("postsFlagged").childByAutoId().updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to flag post:", err)
                    return
                }
                print("Successfully flagged post -> info to db")
            })
            
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        let removeVideo = UIAlertAction(title: "Report ⚠️", style: .destructive) { (action) in
            
            self.flaggedOrReportedPostUrl = "\(HomeController.didSelectPostVideoURL ?? "")"
            print("post reported: \(self.flaggedOrReportedPostUrl ?? "")")
            
            let values = ["\(Auth.auth().currentUser?.uid ?? "")": "\(self.flaggedOrReportedPostUrl ?? "")"]
            
            Database.database().reference().child("postsReported").childByAutoId().updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to flag post:", err)
                    return
                }
                print("Successfully reported post -> info to db")
            })
            
            let reportAlertController = UIAlertController(title: "This post has been Reported!", message: "We will review this post and will update you within under 24 hours", preferredStyle: UIAlertControllerStyle.alert)
            
            reportAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(reportAlertController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(removeVideo)
        alertController.addAction(flagAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleShareButton() {
        
        let activityViewController = UIAlertController()
        
        let textToShare = ["Check out this story I found in storytime: \(self.videoURL ?? "")"]
        let shareActivityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(shareActivityViewController, animated: true, completion: nil)
        
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
        videoURL = "\(UserSearchController.didSelectPostVideoURL ?? "")"
    } 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        playerLayer = AVPlayerLayer(player: player)
        view.addSubview(videoView)
        
        self.view.layer.addSublayer(playerLayer)
        view.addSubview(reportButton)
        view.addSubview(shareButton)
        view.addSubview(profileImageButton)
        playerLayer.frame = view.bounds
        player!.play()
        
        
        reportButton.anchor(top: nil, left: nil, bottom: shareButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -15, paddingRight: 18, width: 50, height: 50)
        
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

