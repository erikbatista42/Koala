//
//  recordViewController.swift
//  Koala
//
//  Created by Erik Batista on 7/21/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class RecordViewController: UIViewController, UIImagePickerControllerDelegate {
    
    let cameraSession = AVCaptureSession()
    
    
    let recordAVideo: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(handleRecordAVideo), for: .touchUpInside)
        return button
    }()
    
    func handleRecordAVideo() {
    
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
    }
    

    
}


