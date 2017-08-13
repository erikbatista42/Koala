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

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let currentUserID = FIRAuth.auth()?.currentUser?.uid ?? ""
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationItem.title = "Koala"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
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
//    var avPlayerViewController = AVPlayerViewController()
//    var avPlayer = AVPlayer()
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let links = posts[indexPath.row]
//        guard let url = NSURL(string: links.videoUrl) else { return }
//        let player = AVPlayer(url: url as URL)
//        let playerController = avPlayerViewController
//        playerController.player = player
//        self.present(playerController, animated: true) {
//            player.play()
//        }
//    }

}
