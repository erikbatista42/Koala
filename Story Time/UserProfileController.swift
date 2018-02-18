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

class UserProfileController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, editProfileAlertView {
    
    weak var delegate: editProfileAlertView?
    let messageComposer = MessageComposer()
    
    var myCollectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    
    var rightBarButtonIsHidden: Bool?
    
    func showAlert() {
        print("hey yo you suck")
    }
    
    let cellId = "cellId"
    var userId: String?
    
    var myUserProfileController: UserProfileController?
    var avPlayerViewController = AVPlayerViewController()
    var avPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 33, green: 41, blue: 67, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir-Black", size: 20) ?? "", NSAttributedStringKey.foregroundColor: UIColor.white]
        
        //        collectionView?.backgroundColor = .white
        
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        myCollectionView.register(UserProfileVideoCell.self, forCellWithReuseIdentifier: cellId)
        
        myCollectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
//        collectionView?.register(UserProfileVideoCell.self, forCellWithReuseIdentifier: cellId)
        myCollectionView.backgroundColor = UIColor.rgb(red: 77, green: 90, blue: 255, alpha: 1)
//        myCollectionView.backgroundColor = UIColor.rgb(red: 205, green: 212, blue: 221, alpha: 1)
        
        fetchUser()
        fetchOrderedPosts()
        setupLogOutButton()
        
        myCollectionView.delegate   = self
        myCollectionView.dataSource = self
        self.view.addSubview(myCollectionView)
    }
    
    var videos = [Post]()
    var thumbnails = [Post]()
    
    fileprivate func fetchOrderedPosts() {
        guard let uid = self.user?.uid else { return }
        let ref = FIRDatabase.database().reference().child("posts").child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            
            guard let user = self.user else { return }
            
            let video = Post(user: user, dictionary: dictionary)
            let thumbnail = Post(user: user, dictionary: dictionary)
            
            self.thumbnails.insert(thumbnail, at: 0)
            self.videos.insert(video, at: 0)
//            self.collectionView?.reloadData()
            self.myCollectionView.reloadData()
        }) { (error) in
            print("Failded to fetch ordered post:", error)
        }
    }
    func editProfileAlert() {
        let alertController = UIAlertController(title: "Stay tuned!", message: "The feature to edit your profile is coming soon 🙃", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        if rightBarButtonIsHidden == true {
                self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Give Feedback", style: .default, handler: { (_) in
            if (self.messageComposer.canSendText()) {
                
                // Obtain a configured MFMessageComposeViewController
                let messageComposeVC = self.messageComposer.configuredMessageComposeViewController()
                //            presentedViewController(messageComposeVC, animated: true, completion: nil)
                self.present(messageComposeVC, animated: true, completion: nil)
            } else {
                let errorAlert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
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
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId , for: indexPath) as! UserProfileVideoCell
        cell.post = thumbnails[indexPath.item]
//        cell.layer.masksToBounds = true
//        cell.layer.cornerRadius = 17
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let links = videos[indexPath.item]
        guard let url = NSURL(string: links.videoUrl) else { return }
        let player = AVPlayer(url: url as URL)
        let playerController = avPlayerViewController
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let width = (view.frame.width - 1) / 2
    //        return CGSize(width: width, height: 189)
    //    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("size for item at")
//        let height: CGFloat = 310 // username + userProfileImageView
//        return CGSize(width: view.frame.width - 27.5, height: height)
//    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 235)
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: 189)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    var user: User?
    
    fileprivate func fetchUser() {
        let uid = userId ?? (FIRAuth.auth()?.currentUser?.uid ?? "")
        FIRDatabase.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.myCollectionView.reloadData()
            self.fetchOrderedPosts()
        }
    }
}


