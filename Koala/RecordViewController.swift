////
////  recordViewController.swift
////  Koala
////
////  Created by Erik Batista on 7/21/17.
////  Copyright © 2017 swift.lang.eu. All rights reserved.
////
//
//import UIKit
//import AVKit
//import AVFoundation
//import MobileCoreServices
//
//class RecordViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    let imagePicker: UIImagePickerController! = UIImagePickerController()
//    let saveFileName = "/test.mp4"
//    
//    
//    let recordAVideo: UIButton = {
//       let button = UIButton()
//        button.addTarget(self, action: #selector(handleRecordAVideo), for: .touchUpInside)
//        return button
//    }()
//    
//    func handleRecordAVideo() {
//        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
//            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
//                
//                imagePicker.sourceType = .camera
//                imagePicker.mediaTypes = [kUTTypeMovie as String]
//                imagePicker.allowsEditing = false
//                imagePicker.delegate = self
//                
//                present(imagePicker, animated: true, completion: {})
//            } else {
//                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
//            }
//        } else {
//            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
//        }
//
//    }
//    
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .blue
//        
//    }
//    
//
//    
////    // Play the video recorded for the app
////    @IBAction func playVideo(_ sender: AnyObject) {
////        print("Play a video")
////        
////        // Find the video in the app's document directory
////        let paths = NSSearchPathForDirectoriesInDomains(
////            FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
////        let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
////        let dataPath = documentsDirectory.appendingPathComponent(saveFileName)
////        print(dataPath.absoluteString)
////        let videoAsset = (AVAsset(url: dataPath))
////        let playerItem = AVPlayerItem(asset: videoAsset)
////        
////        // Play the video
////        let player = AVPlayer(playerItem: playerItem)
////        let playerViewController = AVPlayerViewController()
////        playerViewController.player = player
////        
////        self.present(playerViewController, animated: true) {
////            playerViewController.player!.play()
////        }
////    }
////    
////    // MARK: UIImagePickerControllerDelegate delegate methods
//    // Finished recording a video
//    1 //
//
//    
//}
//
//
