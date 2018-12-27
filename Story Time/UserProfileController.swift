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

protocol GetUserFromUserPorfileCellDelegate {
    func getUser(username: String, profileImage: String, postURL: String)
}

class UserProfileController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var getUserDelegate: GetUserFromUserPorfileCellDelegate?
    
    let messageComposer = MessageComposer()
    
    var myCollectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    
    var rightBarButtonIsHidden: Bool?
    
    let cellId = "cellId"
    var userId: String?
    
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
        myCollectionView.alwaysBounceVertical = true
        myCollectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
//        collectionView?.register(UserProfileVideoCell.self, forCellWithReuseIdentifier: cellId)
        myCollectionView.backgroundColor = UIColor.white
//        myCollectionView.backgroundColor = UIColor.rgb(red: 205, green: 212, blue: 221, alpha: 1)
        
        fetchUser()
        fetchOrderedPosts()
        setupLogOutButton()
        myCollectionView.delegate   = self
        myCollectionView.dataSource = self
        self.view.addSubview(myCollectionView)
        let bottomHeight = ((self.tabBarController?.tabBar.frame.height ?? 0) * 2) + 15 // used to fix the over scroll over collection view
        myCollectionView.contentInset.bottom = bottomHeight
    }
    
    var videos = [Post]()
    var thumbnails = [Post]()
    
    fileprivate func fetchOrderedPosts() {
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
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
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        if rightBarButtonIsHidden == true {
//                self.navigationItem.rightBarButtonItem = nil
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { (_) in
                let alertController = UIAlertController(title: "User has been blocked!", message: "You will no longer see posts from this user", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                self.videos = []
                self.myCollectionView.reloadData()
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
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
    
    var avPlayerViewController = UserProfileVideoPlayer()
    
    var avPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer!
    
    static var didSelectPostUsername: String!
    static var didSelectPostUid: String!
    static var didSelectPostProfileImageURL: String!
    static var didSelectPostVideoURL: String!
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let links = videos[indexPath.item]
        
        UserProfileController.didSelectPostUsername = videos[indexPath.row].user.username
        UserProfileController.didSelectPostUid = videos[indexPath.row].user.uid
        UserProfileController.didSelectPostProfileImageURL = videos[indexPath.row].user.profileImageUrl
        UserProfileController.didSelectPostVideoURL = videos[indexPath.row].videoUrl
        
        getUserDelegate?.getUser(username: UserProfileController.didSelectPostUsername, profileImage: UserProfileController.didSelectPostProfileImageURL, postURL: UserProfileController.didSelectPostVideoURL)
        
        guard let url = NSURL(string: links.videoUrl) else { return }
        var player = avPlayerViewController.player
        player = AVPlayer(url: url as URL)
        let playerItem = AVPlayerItem(url: url as URL)
        avPlayer.replaceCurrentItem(with: playerItem)
        let playerController = avPlayerViewController
        playerController.player = player
        
        let objCreateEventVC = playerController
        objCreateEventVC.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(playerController, animated: true)
        
        self.navigationController?.pushViewController(objCreateEventVC, animated: false)
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
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.myCollectionView.reloadData()
            self.fetchOrderedPosts()
        }
    }
}


