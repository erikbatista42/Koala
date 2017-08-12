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
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import AVFoundation

class VideoSelectorController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
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
    
    var shootADanceButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Shoot a dance", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 24)
        button.backgroundColor = UIColor.rgb(red: 245, green: 50, blue: 97, alpha: 1)
        button.addTarget(self, action: #selector(shootADance), for: .touchUpInside)
        return button
    }()
    
    func shootADance() {
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
        button.setTitle("Upload from library", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 24)
        button.backgroundColor = UIColor.rgb(red: 102, green: 51, blue: 153, alpha: 1)
        button.addTarget(self, action: #selector(handleUploadFromLibraryButton), for: .touchUpInside)
        
        return button
    }()
    
    func handleUploadFromLibraryButton() {
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
        view.backgroundColor = .darkGray
        shootOrUploadBtns()
        
    }
    
    func shootOrUploadBtns() {
        setupNavigationButtons()
        view.addSubview(shootADanceButton)
        shootADanceButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 65, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        
        view.addSubview(uploadFromLibraryButton)
        uploadFromLibraryButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 365, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        _ = FIRStorage.storage().reference().child("videos")
        
        // File located on library
        guard let imagePickerUrl = info[UIImagePickerControllerMediaURL] as? URL else { return }
        let videoUrl = imagePickerUrl
        
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
//
//                 let currentUser = FIRAuth.auth()?.currentUser?.uid
                let thumbnailStorageRef = FIRStorage.storage().reference()

                let imageRef = thumbnailStorageRef.child("thumbnails/" + randomString(length: 20) + ".png")
                
                imageRef.put(imageData, metadata: nil, completion: { (thumbnailMeta, error) in
                    
                    if error != nil {
                        print("An error has occured while uploading thumbnail:",error ?? "")
                    } else {
//                        print(12345)
//                        let dbRef = FIRDatabase.database().reference()
//                        dbRef.child("posts/\(currentUser ?? "")/").childByAutoId().setValue(["thumbnail":"\(String(describing: thumbnailMeta?.downloadURL()))"])
                        print("Thumbnail upload to database was successfull", thumbnailMeta?.downloadURL() ?? "")
                    }
                })
                
            } catch {
                print("An error has occured while making thumbnail:")
            }
    
    
 
//        let thumbnailDownloadUrl = getThumbnailImage(forUrl: videoUrl)
//        
//        print("This issa Thumbnail URl: ",thumbnailDownloadUrl)
        
        
        // Create a reference to the file you want to upload
        let videosRef = FIRStorage.storage().reference().child("videos/\(FIRAuth.auth()?.currentUser?.uid ?? "")/" + randomString(length: 20) + ".mp4")
        
        // Upload the file to the path "videosRef"
        _ = videosRef.putFile(videoUrl, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("An error has occured: \(error)")
                
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                guard let downloadURL = metadata!.downloadURL() else { return }
//                guard let thumb = thum!.dow
                print("ISSA DOWNLOAD URL", downloadURL)
                guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
                
    let userPostRef = FIRDatabase.database().reference().child("posts").child(currentUser)//.child("videoUrl").setValue("\(downloadURL)")
                let ref = userPostRef.childByAutoId()
                
                let values = ["videoUrl": "\(downloadURL)", "thumbnailUrl": "\(""))"]
                
                ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to save video to DB", err)
                        return
                    } else {
                        print("Successfully saved post to DB")
                    }
                })
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
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 41, green: 54, blue: 76, alpha: 1)
    }
    func handleCancel() { dismiss(animated: true, completion: nil) }
}
