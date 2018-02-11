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

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var hpc: HomePostCell!
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
        UIApplication.shared.statusBarStyle = .lightContent
            collectionView?.backgroundColor = UIColor.rgb(red: 77, green: 90, blue: 255, alpha: 1)
        
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
        print(123)
        print("thisss",profileImageView.image ?? "")
        print("user:", user?.username as Any)
    }

    
    fileprivate func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profile_unselected").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleUserProfileButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleShareButton))
    }
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "share_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShareButton() {
        let activityViewController = UIActivityViewController(
            activityItems: ["Check out this app I found called Koala"],applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func handleUserProfileButton() {
        let userProfileController = UserProfileController(nibName:nil, bundle:nil)
        
        (ExploreCV() as? UIViewController)?.navigationController?.pushViewController(userProfileController, animated: true)

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
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        FIRDatabase.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            userIdsDictionary.forEach({ (key,  value) in
                FIRDatabase.fetchUserWithUid(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (err) in
            print("failed to fetch following users ids:", err)
        }
    }
    
    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        FIRDatabase.fetchUserWithUid(uid: currentUserID) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = FIRDatabase.database().reference().child("posts/\(user.uid)/")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
             self.posts.removeAll()
            if #available(iOS 0.0, *) {
               
                
                self.collectionView?.refreshControl?.endRefreshing()
                self.collectionView?.refreshControl?.tintColor = .white
            } else {
                // Fallback on earlier versions
            }
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key,value) in
                
                guard let dictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
                FIRDatabase.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    var avPlayerViewController = VideoPlayerViewController()
    
    var avPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer!
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let links = posts[indexPath.row]
        guard let url = NSURL(string: links.videoUrl) else { return }
        let player = AVPlayer(url: url as URL)
        let playerController = avPlayerViewController
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
    

//
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

