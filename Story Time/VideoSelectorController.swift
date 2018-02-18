//
//  PhotoSelectorController.swift
//  Koala
//
//  Created by Erik Batista on 7/8/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import AVFoundation

class VideoSelectorController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    let currentUser = FIRAuth.auth()?.currentUser?.uid
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
    var user: User? {
        didSet {
            
        }
    }
    
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    var shootAStoryButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Shoot a Story", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 24)
        button.backgroundColor = UIColor.rgb(red: 252, green: 41, blue: 125, alpha: 1)
        button.addTarget(self, action: #selector(shootADance), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = false
        return button
    }()
    
    @objc func shootADance() {
                 if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
              
                //if the camera is available, and if the rear camera is available, the let the image picker do this
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = true
                imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.videoMaximumDuration = 60
                imagePicker.videoQuality = .typeIFrame960x540
                present(imagePicker, animated: true, completion: nil)
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    var uploadFromLibraryButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload From Library", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 24)
        button.backgroundColor = UIColor.rgb(red: 250, green: 107, blue: 65, alpha: 1)
        button.addTarget(self, action: #selector(handleUploadFromLibraryButton), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = false
        return button
    }()
    
    @objc func handleUploadFromLibraryButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var prefersStatusBarHidden: Bool { return true }
        self.imagePicker.delegate = self 
        view.backgroundColor = UIColor.rgb(red: 28, green: 34, blue: 55, alpha: 1)
        shootOrUploadBtns()
        setupUserStatsView()
    }
    
    func shootOrUploadBtns() {
        setupNavigationButtons()
        view.addSubview(shootAStoryButton)
//        shootAStoryButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 0, height: 100)
//        shootAStoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.addSubview(uploadFromLibraryButton)
//        uploadFromLibraryButton.anchor(top: shootAStoryButton.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 0, height: 100)
//        uploadFromLibraryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [shootAStoryButton,uploadFromLibraryButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 24, paddingBottom: -55, paddingRight: 24, width: 0, height: 50)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "update feed")
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        _ = FIRStorage.storage().reference().child("videos")
        
        // File located on library
        guard let imagePickerUrl = info[UIImagePickerControllerMediaURL] as? URL else { return }
        let videoUrl = imagePickerUrl
        
//        let thumbnailDownloadUrl = getThumbnailImage(forUrl: videoUrl)
//        
//        print("This issa Thumbnail URl: ",thumbnailDownloadUrl)
        
        
        // Create a reference to the file you want to upload
        let videosRef = FIRStorage.storage().reference().child("videos/\(currentUser)/" + randomString(length: 20) + ".mp4")
        
        let allVideos = FIRStorage.storage().reference().child("all_videos/" + randomString(length: 20) + ".mp4")
        
        // Upload the file to the path "videosRef"
        _ = allVideos.putFile(videoUrl, metadata: nil) { metadata, error in
            if let error = error {
                print("An error has occured: \(error)")
            } else {
                //GenerateThumbnail
                let asset: AVAsset = AVAsset(url: videoUrl)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true
                var time = asset.duration
                time.value = min(time.value, 3)
                
                do {
                    let thumbnailImage = try imageGenerator.copyCGImage(at: time , actualTime: nil)
                    let image = UIImage(cgImage: thumbnailImage)
                    guard let imageData = UIImagePNGRepresentation(image) else { return }
                    
                    if UIImagePNGRepresentation(image) != nil {
                        print("Image data: \(imageData)")
                    } else {
                        print("IMG DATA IS NIL")
                    }
                    
                    let thumbnailStorageRef = FIRStorage.storage().reference()
                    
                    let imageRef = thumbnailStorageRef.child("thumbnails/" + self.randomString(length: 20) + ".png")
                    
                    imageRef.put(imageData, metadata: nil, completion: { (thumbnailMeta, error) in
                        
                        if error != nil {
                            print("An error has occured while uploading thumbnail:",error ?? "")
                        } else {
                            guard let thumbnailUrl = thumbnailMeta?.downloadURL() else { return }
                            print("Thumbnail upload to database was successfull:", thumbnailUrl)
                            
                            // Metadata contains file metadata such as size, content-type, and download URL.
                            guard let downloadURL = metadata!.downloadURL() else { return }
                            
                            print("Video url that was recently uploaded:", downloadURL)
                            guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
                            
                            let userPostRef = FIRDatabase.database().reference().child("posts").child(currentUser)
                            let ref = userPostRef.childByAutoId()
                            
                            let values = ["videoUrl": "\(downloadURL)", "thumbnailUrl": "\(thumbnailUrl)", "creationDate" : Date().timeIntervalSince1970] as [String : Any]
                            
                            
                            NotificationCenter.default.post(name: VideoSelectorController.updateFeedNotificationName, object: nil)
                            
                            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                if let err = err {
                                    print("Failed to save video to DB", err)
                                    return
                                } else {
                                    print("Successfully saved post to DB")
                                }
                            })
                        }
                    })
                    
                } catch {
                    print("An error has occured while making thumbnail:")
                }
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrtstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let len = Int32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let random = arc4random_uniform(UInt32(len))
            var nextCharacter = letters.character(at: Int(random))
            randomString += NSString(characters: &nextCharacter, length: 1) as String
        }
        return randomString
    }
    
    fileprivate func  setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 28, green: 34, blue: 55, alpha: 1)
    }
    @objc func handleCancel() { dismiss(animated: true, completion: nil) }
}
