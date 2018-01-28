//
//  ExploreCV.swift
//  Vlogr
//
//  Created by Erik Batista on 1/27/18.
//  Copyright © 2018 kennybatista. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVFoundation
import AVKit

class ExploreCV: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellId = "cellId"
    var collectionView: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(ExploreCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        fetchAllPost()
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        let navBar = navigationController?.navigationBar
        navBar?.topItem?.title = "Explore"
        navBar?.barTintColor   = UIColor.rgb(red: 48, green: 73, blue: 119, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        
        
    }
    
    func handleDone() {
        print("done")
    }
    
    func handleUpdateFeed() {
        handleRefresh()
    }
    
    func handleRefresh() {
        print("handling refresh..")
        posts.removeAll()
        fetchAllPost()
    }
    
    fileprivate func fetchAllPost() {
        fetchAllPostsFromUserIds()
    }
    
    fileprivate func fetchAllPostsFromUserIds() {
        FIRDatabase.database().reference().child("posts").observeSingleEvent(of: .value, with: { (children) in
            guard let userIdsDictionary = children.value as? [String: Any] else { return }
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
                var  post = Post(user: user, dictionary: dictionary)
                post.id = key
                guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
                FIRDatabase.database().reference().child("likes").child(key).child(uid).observe(.value, with: { (snapshot) in
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
                    print("Failed to fetch info for post")
                })
                print(self.posts)
            })
        }) { (error) in
            print("Failed to fetch posts", error)
        }
    }
    
    var avPlayerViewController = AVPlayerViewController()
    var avPlayer = AVPlayer()
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let links = posts[indexPath.row]
        guard let url = NSURL(string: links.videoUrl) else { return }
        let player = AVPlayer(url: url as URL)
        let playerController = avPlayerViewController
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of posts fetched: \(posts.count)")
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExploreCell
       
        cell.backgroundColor = UIColor.clear
        cell.thumbnail = posts[indexPath.item]
        
        return cell
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
    
}
