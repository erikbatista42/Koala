//
//  UserProfileController.swift
//  Koala
//
//  Created by Erik Batista on 7/6/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import AVFoundation
import UIKit
import AVKit
import Firebase
import MobileCoreServices




class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var userId: String?
    
    var myUserProfileController: UserProfileController?
    let currentUserID = FIRAuth.auth()?.currentUser?.uid ?? ""
    var avPlayerViewController = AVPlayerViewController()
    var avPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 59, green: 89, blue: 152, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Black", size: 20) ?? "", NSForegroundColorAttributeName: UIColor.white]
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfileVideoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.rgb(red: 59, green: 89, blue: 152, alpha: 1)
        fetchUser()
        fetchOrderedPosts()
        setupLogOutButton()
    }
    
    var videos = [Post]()
    var thumbnails = [Post]()
    
    
    fileprivate func fetchOrderedPosts() {
        let ref = FIRDatabase.database().reference().child("posts").child(currentUserID)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            
            guard let user = self.user else { return }
            
            let video = Post(user: user, dictionary: dictionary)
            let thumbnail = Post(user: user, dictionary: dictionary)
            
            self.thumbnails.insert(thumbnail, at: 0)
            self.videos.insert(video, at: 0)


            
            self.collectionView?.reloadData()
            
        }) { (error) in
            print("Failded to fetch ordered post:", error)
        }
    }
    
    
   fileprivate func fetchposts() {
    
    let ref = FIRDatabase.database().reference().child("posts").child(currentUserID)
    
    ref.observeSingleEvent(of: .value, with: { (snapshot) in

        guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key,value) in
                
                guard let user = self.user else { return }
                guard let dictionary = value as? [String: Any] else { return }
                let video = Post(user: user, dictionary: dictionary)
                let thumbnail = Post(user: user, dictionary: dictionary)
                
                self.thumbnails.append(thumbnail)
                self.videos.append(video)
                print(self.videos)
                print(self.thumbnails)
            })
        
        self.collectionView?.reloadData()
        
        }) { (error) in
            print("Failed to fetch videos", error)
    }
}

    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
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
        
        cell.thumbnail = thumbnails[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let links = videos[indexPath.item] //change to .row if necessary
//        print("Links: \(links)")
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
        let uid = userId ?? FIRAuth.auth()?.currentUser?.uid ?? ""
//        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FIRDatabase.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()

        }        
    }
}
                            



