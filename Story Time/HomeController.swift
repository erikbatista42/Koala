//
//  HomeController.swift
//  Koala
//
//  Created by Erik on 8/7/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import AVKit

protocol GetUserFromHomeControllerCellDelegate {
    func getUser(username: String, profileImage: String, postURL: String)
}

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var getUserDelegate: GetUserFromHomeControllerCellDelegate?
    
    var hpc: HomePostCell!
//    var delegate: VideoUrlDelegate?
    var userId: String?
    
    var user: User? {
        didSet {
//            guard let profileImageUrl = user?.profileImageUrl else { return }
//            profileImageView.loadImage(UrlString: profileImageUrl)
        }
    }
    
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.layer.zPosition = 0
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        UIApplication.shared.statusBarStyle = .lightContent
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.register(HomeControllerHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeControllerHeaderId")
        
        let refreshControll = UIRefreshControl()
        
        refreshControll.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControll
            
        } else {
            // Fallback on earlier versions
            
        }
        
        setupNavigationItems()
        fetchAllPost()
        setupBarButtons()
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.rgb(red: 44, green: 53, blue: 151, alpha: 1).cgColor
        return iv
    }()
    
    lazy var profileButton: UIButton = {
       let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 30, height: 30)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        let image = profileImageView.image
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func profileButtonPressed() {
        print("thisss",profileImageView.image ?? "")
        print("user:", user?.username as Any)
    }
    
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "People's videos will pop up here once you follow them!"
        label.font = UIFont.systemFont(ofSize: 16)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.gray
        label.numberOfLines = 3
        label.textAlignment = .center
        
        return label
    }()

    
    fileprivate func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profile_unselected").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleUserProfileButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleOptionsButton))
    }
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "share_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleOptionsButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleOptionsButton() {
        
        let activityViewController = UIAlertController()
        
        let contactCreaterButton = UIAlertAction(title: "Contact Creator 📩", style: .default, handler: { (action) -> Void in
            print(123)
            // exclude some activity types from the list (optional)
            //        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        })
        
        let shareApp = UIAlertAction(title: "Share App 👥", style: .default, handler: { (action) -> Void in
            print("share app button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        activityViewController.addAction(contactCreaterButton)
        activityViewController.addAction(shareApp)
        activityViewController.addAction(cancelButton)
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
//        let activityViewController = UIActivityViewController(
//            activityItems: ["Check out this app I found called Story Time"],applicationActivities: nil)
//        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func handleUserProfileButton() {
        let userProfileController = UserProfileController(nibName:nil, bundle:nil)
        
        ExploreVC().navigationController?.pushViewController(userProfileController, animated: true)

        self.navigationController?.pushViewController(userProfileController, animated: true)
    }

    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        
        fetchAllPost()
    }

    fileprivate func fetchAllPost() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            userIdsDictionary.forEach({ (key,  value) in
                Database.fetchUserWithUid(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (err) in
            print("failed to fetch following users ids:", err)
        }
    }
    
    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUid(uid: currentUserID) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts/\(user.uid)/")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
             self.posts.removeAll()
            if #available(iOS 0.0, *) {
                self.collectionView?.refreshControl?.endRefreshing()
                self.collectionView?.refreshControl?.tintColor = .black
            } else {
                // Fallback on earlier versions
            }
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key,value) in
                
                guard let dictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (err) in
                    print("Failed to fetch info for post", err)
                })
            })
        }) { (error) in
            print("Failed to fetch posts", error)
        }
    }
    
    func setupNavigationItems() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 33, green: 41, blue: 67, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Black", size: 20) ?? "", NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 2
        return CGSize(width: width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if posts.count == 0
        
        {
            view.addSubview(noDataLabel)
            noDataLabel.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
            collectionView.backgroundView = nil
        } else {
            noDataLabel.isHidden = true 
        }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        //        self.hpc = cell
        cell.post = posts[indexPath.item]
        
        return cell
    }

    
    func didPressShareButton(for cell: HomePostCell) {
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        
        let post = self.posts[indexPath.item]
        guard let url = NSURL(string: post.videoUrl) else { return }
        let activityViewController = UIActivityViewController(
            activityItems: ["Check out this video I found on Vlogger: \(url)"],applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    var avPlayerViewController = HomeControllerVideoPlayer()
    
    var avPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer!
    
    static var didSelectPostUsername: String!
    static var didSelectPostUid: String!
    static var didSelectPostProfileImageURL: String!
    static var didSelectPostVideoURL: String!
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let links = posts[indexPath.row]
        
        HomeController.didSelectPostUsername = posts[indexPath.row].user.username
        HomeController.didSelectPostUid = posts[indexPath.row].user.uid
        HomeController.didSelectPostProfileImageURL = posts[indexPath.row].user.profileImageUrl
        HomeController.didSelectPostVideoURL = posts[indexPath.row].videoUrl
        
        
        getUserDelegate?.getUser(username: HomeController.didSelectPostUsername, profileImage: HomeController.didSelectPostProfileImageURL, postURL: HomeController.didSelectPostVideoURL)
        
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
  
//    func didLike(for cell: HomePostCell) {
//
//        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
//
//        var post = self.posts[indexPath.item]
//
//        guard let postId = post.id else { return }
//
//        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
//
//        let values = [uid : post.hasLiked == true ? 0 : 1]
//
//        FIRDatabase.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
//            if let err = err {
//                print("Failed to like post", err)
//                return
//            }
//
//            post.hasLiked = !post.hasLiked
//
//            self.posts[indexPath.item] = post
//
//            self.collectionView?.reloadData()
//        }
//
//    }
}

