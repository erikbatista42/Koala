//
//  UserSearchController.swift
//  Koala
//
//  Created by Erik Batista on 8/26/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVFoundation
import AVKit

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UISearchBarDelegate, UISearchDisplayDelegate, GetUserSearchControllerDelegate {
    
    let cellId = "cellId"
 
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.barTintColor = UIColor.gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        sb.keyboardAppearance = .dark
        sb.delegate = self
        return sb
    }()
    
    fileprivate func setupNavBarAndSearchBar() {
        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey : AnyObject], for: .normal)
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 33, green: 41, blue: 67, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        let navBar = navigationController?.navigationBar
        searchBar.delegate = self
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchUsersCV.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchUsersCV.isHidden = true
    }
    
    let searchUsersCV: SearchUsersCV = {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth  = UIScreen.main.bounds.width
        let cv = SearchUsersCV(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        cv.bringSubview(toFront: cv)
        cv.collectionView.register(UserSearchCVCell.self, forCellWithReuseIdentifier: "cellId")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarAndSearchBar()
        collectionView?.backgroundColor = UIColor.rgb(red: 77, green: 90, blue: 255, alpha: 1)
        collectionView?.register(ExploreCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(searchUsersCV)
        searchUsersCV.isHidden = true
        fetchUsers()
        searchUsersCV.delegate = self
        fetchAllPost()
        UIApplication.shared.statusBarStyle = .lightContent
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
    //    var posts = [Post]()
    //    fileprivate func fetchPosts() {
    //        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
    //        FIRDatabase.fetchUserWithUid(uid: currentUserID) { (user) in
    //            self.fetchPostsWithUser(user: user)
    //        }
    //    }
    
    func handleUpdateFeed() {
        handleRefresh()
    }
    
    func handleRefresh() {
        print("handling refresh..")
        posts.removeAll()
        fetchAllPost()
    }
    
    fileprivate func fetchAllPost() {
        //        fetchPosts()
        fetchAllPostsFromUserIds()
    }
    
    fileprivate func fetchAllPostsFromUserIds() {
        //        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
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
    
    func searchControllerDidSelect(passedUser: String) {
        self.searchBar.isHidden = true
        
        searchBar.resignFirstResponder()
        // FIX THIS
        let userProfileController = UserProfileController(nibName:nil, bundle:nil)
        userProfileController.rightBarButtonIsHidden = true
        userProfileController.userId = passedUser
        //        userProfileController.videos = [passedVideos]
        //        userProfileController.thumbnails = [passedThumbnail]
        (searchUsersCV.next as? UIViewController)?.navigationController?.pushViewController(userProfileController, animated: true)
        self.navigationController?.pushViewController(userProfileController, animated: true)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            let vc = segue.destination as! UserProfileController
//            vc.leftBarButtonIsHidden = true
//    }
//    
    var filteredUsers = [User]()
    var users = [User]()
    func fetchUsers() {
        let ref = FIRDatabase.database().reference().child("users")
        ref.observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            //For each iterates through every object in the dictioary
            dictionaries.forEach({ (key, value) in
                
                if key == FIRAuth.auth()?.currentUser?.uid {
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return}
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
                print(user.uid, user.username)
            })
            self.collectionView?.reloadData()
        }) { (error) in
            print("failed to fetch users:", error)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.users.sort { (u1, u2) -> Bool in
            return u1.username.compare(u2.username) == .orderedAscending
        }
        searchUsersCV.isHidden = false
        searchUsersCV.updateUsersView(self.filteredUsers)
        
        self.collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of posts fetched: \(posts.count)")
        return posts.count
        //        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExploreCell
        cell.thumbnail = posts[indexPath.item]
        
        // Makes cell corners round
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2.1) / 2.1
        return CGSize(width: width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func random(maximum: UInt32, minimum: CGFloat = 0) -> CGFloat {
        return max(CGFloat(arc4random_uniform(maximum)), minimum)
    }
}

