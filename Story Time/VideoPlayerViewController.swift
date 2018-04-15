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

//    var videoUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
//        self.tabBarController?.tabBar.isHidden = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        playerLayer = AVPlayerLayer(player: player)
        //        videoView.layer.addSublayer(playerLayer)
        view.addSubview(videoView)
        videoView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.view.layer.addSublayer(playerLayer)
        playerLayer.frame = view.bounds
        player!.play()
        
//        viewDidLayoutSubviews()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
////        playerLayer.frame = view.bounds
//        player!.play()
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        player!.pause()
        player = nil
        playerLayer.removeFromSuperlayer()
//        view.layer.sublayers?.removeAll()
//        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//        view.layer.sublayers = nil 
//        view.layer.sublayers = nil
//        for layer: CALayer in self.view.layer.sublayers! {
//            layer.removeFromSuperlayer()
//        }
//        player.pause()
       
    }
 
//    func setupPlayerView(playerItem: AVPlayerItem?) {
//        guard self.player == nil && playerItem != nil else { return }
//
//        // Create an AVPlayer and AVPlayerLayer with the AVPlayerItem.
//        self.player = AVPlayer(playerItem: playerItem)
//        let playerLayer = AVPlayerLayer(player: player)
//
//        // Configure the AVPlayerLayer and add it to the view.
//        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//        playerLayer.frame = (self.videoView.bounds)
//        self.videoView.layer.addSublayer(playerLayer)
//        videoView.layer.addSublayer(playerLayer)
//        print("doing something")
//    }
    
}
