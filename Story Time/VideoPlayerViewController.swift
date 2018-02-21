//
//  VideoPlayerViewController.swift
//  Koala
//
//  Created by Erik Batista on 1/31/18.
//  Copyright © 2018 swift.lang.eu. All rights reserved.
//

import UIKit
import AVFoundation

//protocol VideoUrlDelegate {
//    func passVideoUrl(passedVideoUrl: NSURL)
//}

class VideoPlayerViewController: UIViewController {
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
//    var delegate: VideoUrlDelegate?
    
    let videoView: UIView = {
       let vidView = UIView()
        
        return vidView
    }()

    var videoUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.tabBarController?.tabBar.isHidden = true
        
        playerLayer = AVPlayerLayer(player: player)

        videoView.layer.addSublayer(playerLayer)

        view.addSubview(videoView)
        videoView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        player.play()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let play = player {
            print("stopped")
            play.pause()
            player = nil
            
            print("player deallocated")
        } else {
            print("player was already deallocated")
        }
    }
 
}
