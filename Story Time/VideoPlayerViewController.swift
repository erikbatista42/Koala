//
//  VideoPlayerViewController.swift
//  Koala
//
//  Created by Erik Batista on 1/31/18.
//  Copyright © 2018 swift.lang.eu. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase



class VideoPlayerViewController: UIViewController, GetUserFromCellDelegate {
    
    
    
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
        return iv
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.white])
        label.attributedText = attributedText
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
      
//        userProfileImageView.layer.cornerRadius = 30/2
        
        
//        view.addSubview(timeLabel)
//        timeLabel.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 150, height: 50)
    }
    
    func getUser(username: String, profileImage: String, postURL: String) {
        guard let profileImageUrl = HomeController.didSelectPostProfileImageURL else { return }
        userProfileImageView.loadImage(UrlString: profileImageUrl)
        print("user post profile image: ", HomeController.didSelectPostProfileImageURL)
        print("user post username: ", HomeController.didSelectPostUsername)
        print("user post URL: ", HomeController.didSelectPostVideoURL)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        playerLayer = AVPlayerLayer(player: player)
        view.addSubview(videoView)
        

//        videoView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.view.layer.addSublayer(playerLayer)
        view.addSubview(userProfileImageView)
        playerLayer.frame = view.bounds
        player!.play()
        userProfileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 18, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        // Make repeat when it reaches the end
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.player?.seek(to: kCMTimeZero)
            self.player?.play()
        }

        let callGetUserFunction = "call"
        getUser(username: callGetUserFunction, profileImage: callGetUserFunction, postURL: callGetUserFunction)
    }
    
    

    override func viewDidDisappear(_ animated: Bool) {
        player!.pause()
        player = nil
        playerLayer.removeFromSuperlayer()
    }

}
