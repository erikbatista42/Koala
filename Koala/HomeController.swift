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

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    var hpc: HomePostCell!
    
    var user: User? {
        didSet {
            
            //            usernameLabel.text = "@\(user?.username ?? "")"
            //            guard let numOfPosts = user?.numOfPosts else { return }
            //            vloggiesLabel.text = "\(numOfPosts)"
            //            print("this is the number of posts: \(numOfPosts)")
            //nothing here
        }
    }
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(reload(likesLabelNotification:homePostCellNotification:)), name: NSNotification.Name(rawValue: "homePostCellRawValue"), object: nil)
        UIApplication.shared.statusBarStyle = .lightContent
        //        collectionView?.backgroundColor = .white
        collectionView?.backgroundColor = UIColor.rgb(red: 205, green: 212, blue: 221, alpha: 1)
        
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
        setupExploreButton()
    }
    fileprivate func setupExploreButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleExploreButton))
    }
    
    @objc func handleExploreButton() {

        let exploreCollectionView = ExploreCV()
        let navigationController = UINavigationController(rootViewController: exploreCollectionView)
        
        present(navigationController, animated: true, completion: nil)
        
//        func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//            let presentedViewController = ExploreCV()
//
//            let dismissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: Selector(("dismissPopover:")))
//
//            presentedViewController.navigationItem.rightBarButtonItem = dismissButton
//
//            return navigationController
//        }
        
//        func dismissPopover(sender: AnyObject) {
//            self.dismiss(animated: true, completion: nil)
//        }
    }

    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
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
            
            if #available(iOS 10.0, *) {
                self.collectionView?.refreshControl?.endRefreshing()
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 208, green: 2, blue: 27, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Home"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Black", size: 20) ?? "", NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 310 // username + userProfileImageView
        return CGSize(width: view.frame.width - 27.5, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        self.hpc = cell
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload(likesLabelNotification:)), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
        cell.post = posts[indexPath.item]
        cell.delegate = self
        
        // Makes cell corners round
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 17
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: view.frame.width, height: 5)
    //    }
    //
    //    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeControllerHeaderId", for: indexPath) as! HomeControllerHeader
    //
    //        return header
    //    }
    
    @objc func reload(likesLabelNotification: Notification) {
        
        //        guard let likesLabel = likesLabelNotification.userInfo?["likesLabelInfo"] as? UILabel else { return }
        //        guard let indexPath = collectionView?.indexPath(for: hpc) else { return }
        //
        //        let post = self.posts[indexPath.item]
        //        guard let postId = post.id else { return }
        //        let postUserId = post.user.uid
        //
        ////        guard let uid = self.user?.uid else { return }
        //        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        //
        //        let numOfLikesRef = FIRDatabase.database().reference().child("likes").child(postId)
        //
        //        numOfLikesRef.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
        //            likesLabel.isHidden = false
        //
        //            let numOfChildrens = snapshot.childrenCount
        //            likesLabel.text = "\(numOfChildrens)"
        //            print("Snapshot:", snapshot)
        //            print("childrens: ", numOfChildrens)
        //            print("post user:", postUserId)
        //            print("self user uid: ", uid)
        //        }, withCancel: { (error) in
        //            print("failed to fetch num of posts: ",error)
        //        })
        //        self.posts[indexPath.item] = post
        //
        //        self.collectionView?.reloadData()
    }
    
    func didPressShareButton(for cell: HomePostCell) {
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        
        let post = self.posts[indexPath.item]
        guard let url = NSURL(string: post.videoUrl) else { return }
        let activityViewController = UIActivityViewController(
            activityItems: ["Check out this video I found on Vlogger: \(url)"],applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    var avPlayerViewController = AVPlayerViewController()
    var avPlayer = AVPlayer()
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
    
    func didLike(for cell: HomePostCell) {
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        
        var post = self.posts[indexPath.item]
        
        guard let postId = post.id else { return }
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let values = [uid : post.hasLiked == true ? 0 : 1]
        
        FIRDatabase.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to like post", err)
                return
            }
            
            post.hasLiked = !post.hasLiked
            
            self.posts[indexPath.item] = post
            
            self.collectionView?.reloadData()
        }
        
    }
}

