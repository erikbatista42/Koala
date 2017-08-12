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
import MobileCoreServices

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let currentUserID = FIRAuth.auth()?.currentUser?.uid ?? ""
    let cellId = "cellId"
    
    var avPlayerViewController = AVPlayerViewController()
    var avPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = currentUserID
        fetchUser()
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 41, green: 54, blue: 76, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfileVideoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.rgb(red: 14, green: 14, blue: 14, alpha: 1)
      
        
        fetchposts()
        setupLogOutButton()
    }
    
    var videos = [Post]()
    var videosThumbnails = [Post]()
   fileprivate func fetchposts() {
    
    let ref = FIRDatabase.database().reference().child("posts").child(currentUserID)
    
    ref.observeSingleEvent(of: .value, with: { (snapshot) in

        guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key,value) in

                guard let dictionary = value as? [String: Any] else { return }
                let video = Post(dictionary: dictionary)
                self.videos.append(video)
                print(self.videos)
                
            })
        
        self.collectionView?.reloadData()
        
        }) { (error) in
            print("Failed to fetch videos", error)
    }
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId , for: indexPath) as! UserProfileVideoCell
        
//        cell.video = videos[indexPath.item]
        
        
        let links =  videos[indexPath.row]
        let url = NSURL(string: links.videoUrl)
        let thumnailMaker = cell.getThumbnailImage(forUrl: (url as URL?)!)
        cell.thumbNailImageView.image = thumnailMaker
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let links = videos[indexPath.row]
        print("Links: \(links)")
        guard let url = NSURL(string: links.videoUrl) else { return }
        let player = AVPlayer(url: url as URL)
        let playerController = avPlayerViewController
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 1) / 2
        return CGSize(width: width, height: 189)
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


