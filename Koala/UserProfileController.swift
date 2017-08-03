//
//  UserProfileController.swift
//  Koala
//
//  Created by Erik Batista on 7/6/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Kingfisher
import AVKit
import AVFoundation


class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var videoDownloadLinks = [String]()
    var videoThumbnailLinks = [String]()
    
    var avPlayerViewController = AVPlayerViewController()
    var avPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = FIRAuth.auth()?.currentUser?.uid
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 41, green: 54, blue: 76, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.rgb(red: 14, green: 14, blue: 14, alpha: 1)
      
        setupLogOutButton()
        
        loadThumbNail()
        
    }
    
    func loadThumbNail() {
        let databaseReference = FIRDatabase.database().reference().child("videos")
        
        databaseReference.observe(.childAdded, with: {
            snapshot in
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            let videoDownloadURL = postDict["videodownloadlink"]!
            let videoThumbnail = postDict["thumbnail"]!
            
            self.videoDownloadLinks.insert(videoDownloadURL as! String, at: 0)
            self.videoThumbnailLinks.insert(videoThumbnail as! String, at: 0)
            
            self.collectionView?.reloadData()
            print(self.videoDownloadLinks.count)
            print(self.videoThumbnailLinks.count)
            
//            self.vloggiesNumber += 1
            
//            self.vloggies.text = String(describing: self.vloggiesNumber)
        })
        

    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    func handleLogOut() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try FIRAuth.auth()?.signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            } catch let signOutErr {
                print("Failed to sign out", signOutErr)
         }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    var numVideos = [uint(Int())]
//    var numbVideos = uint
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        let refDb = FIRDatabase.database().reference()
        refDb.child("users/\(FIRAuth.auth()?.currentUser?.uid ?? "")/videos")
        
        refDb.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
            
            print(snapshot.childrenCount)
           self.numVideos = [uint(snapshot.childrenCount)]
            

        })
        
        print("num of videos: \(numVideos.count)")
        
//        return numVideos.count
        return 7
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId , for: indexPath) as! MainCollectionViewCell
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func playVideo() {
        
//        // Create a reference to the file you want to download
//         let path = FIRStorage.storage().reference().child("videos/cFnswXmYnDJP6IuvqMud.mp4")
//        
//        // Create local filesystem URL
//        let localURL = URL(string: "videos/cFnswXmYnDJP6IuvqMud.mp4")!
        
        // Create a reference with an initial file path and name
        let pathReference = FIRStorage.storage().reference(withPath: "videos/HWlqz3nxGJt575EJpmfk.mp4")
        
        // Create a reference from a Google Cloud Storage URI
        let gsReference = FIRStorage.storage().reference(forURL: "gs://koala-60599.appspot.com/videos/\(FIRAuth.auth()?.currentUser?.uid ?? ""))")
        
        // Create a reference from an HTTPS URL
        // Note that in the URL, characters are URL escaped!
        let httpsReference = FIRStorage.storage().reference(forURL: "gs://koala-60599.appspot.com/videos")
//        
        // Download to the local filesystem
//        let downloadTask = pathReference.write(toFile: gsReference) { url, error in
//            if let error = error {
//                // Uh-oh, an error occurred!
//                let alertController = UIAlertController(title: "ERORR", message: "Koala couldn't load video, please try again later", preferredStyle: .alert)
//                
//                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action -> Void in
//                    // Put your code here
//                })
//                self.present(alertController, animated: true, completion: nil)
//                print("AN ERROR HAS OCCURED \(error)")
//                
//            } else {
//                // Local file URL for "images/island.jpg" is returned
//                let player = AVPlayer(url: localURL)
//                let playerController = AVPlayerViewController()
//                playerController.player = player
//                self.present(playerController, animated: true) {
//                player.play()
//                }
//            }
//        }
        
        // Create a reference to the file you want to download
        let videosRef = FIRStorage.storage().reference().child("videos/cFnswXmYnDJP6IuvqMud.mp4")
        
        // Fetch the download URL
        videosRef.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print("ERRORRRR: \(error)")
            } else {
                // Get the download URL for 'images/stars.jpg'
                print(videosRef)
                // Local file URL for "images/island.jpg" is returned
              guard let theURL = url else { return }
                    let player = AVPlayer(url: theURL)
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    self.present(playerController, animated: true) {
                        player.play()
                }
            }
        }
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("A cell has been selected")
//            let linkToDownload = videoDownloadLinks[indexPath.row]
//            let url = NSURL(string: linkToDownload)
            playVideo()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: 175)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 235)
    }
    
    var user: User?
    
    fileprivate func fetchUser() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        //The FIRDatabase.database().reference() gives you access to the firebase database and once you call .child(users) you access to the child of the users of firebase 
        //Observe single event is just a fancy word to give me the username instead of observing the uid
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            self.user = User(dictionary: dictionary)
            
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch user")
        }
    }
}
                            
struct User {
    let username: String
    let profileImageUrl: String
    let videos: String
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.videos = dictionary["Videos"] as? String ?? ""
    }
}


