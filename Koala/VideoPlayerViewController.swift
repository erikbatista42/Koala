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
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    let videoView: UIView = {
       let vidView = UIView()
        
        return vidView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/vlogr-9384d.appspot.com/o/all_videos%2Fv0t1ICaujj4NuHt6ApgS.mp4?alt=media&token=16ca09af-a3c1-4985-af47-fef7969c9bbc")!
        player = AVPlayer(url: url)
        
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
    
    
    
}
