//
//  VideoPlayerViewController.swift
//  Koala
//
//  Created by Erik Batista on 1/31/18.
//  Copyright © 2018 swift.lang.eu. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    var hc: HomeController!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    let videoView: UIView = {
       let vidView = UIView()
       return vidView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        playerLayer = AVPlayerLayer(player: player)
        view.addSubview(videoView)
        videoView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.view.layer.addSublayer(playerLayer)
        playerLayer.frame = view.bounds
        player!.play()
        
        // Make repeat when it reaches the end
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.player?.seek(to: kCMTimeZero)
            self.player?.play()
        }
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        player!.pause()
        player = nil
        playerLayer.removeFromSuperlayer()
    }

}
