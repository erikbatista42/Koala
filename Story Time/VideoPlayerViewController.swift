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
    
//    var url = URL(string: "https://firebasestorage.googleapis.com/v0/b/koala-60599.appspot.com/o/videos%2FOptional(%22Z8NBcoygSHcg1wXtCZqeCVdUev12%22)%2FJacfaUVaQsbi9Uc0184E.mp4?alt=media&token=e65756eb-1642-4e9e-8080-f42621322b70")!
    
//     guard let url = NSURL(string: links.videoUrl) else { return }
//    var videoUrl = URL(string: ())!
    
    var videoUrl: URL!
    
//    let videoUrl = URL(String)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
//        print("issa:", videoUrl)
//        player = AVPlayer(url: videoUrl)
//        url = URL(string: "https://www.apple.com")

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
