//
//  HomeController.swift
//  Koala
//
//  Created by Erik on 8/7/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MobileCoreServices
import AVFoundation
import AVKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    let currentUserID = FIRAuth.auth()?.currentUser?.uid ?? ""
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        fetchposts()
    }
    
    
    var posts = [Post]()
    fileprivate func fetchposts() {
        
         let ref = FIRDatabase.database().reference().child("posts/\(currentUserID)/")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key,value) in
                
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
                print(self.posts)
                
            })
            
            self.collectionView?.reloadData()
            
        }) { (error) in
            print("Failed to fetch videos", error)
        }
    }

    
    func setupNavigationItems() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 59, green: 89, blue: 152, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Home"
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Black", size: 20) ?? "", NSForegroundColorAttributeName: UIColor.white]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 // username + userProfileImageView
        height += view.frame.width
        height += 50
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
//        let links =  posts[indexPath.row]
//        let url = NSURL(string: links.videoUrl)
//        let thumnailMaker = cell.getThumbnailImage(forUrl: (url as URL?)!)
//        cell.thumbNailImageView.image = thumnailMaker
        
        
        return cell
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

}
