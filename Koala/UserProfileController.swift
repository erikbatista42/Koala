//
//  UserProfileController.swift
//  Koala
//
//  Created by Erik Batista on 7/6/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserProfileController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = FIRAuth.auth()?.currentUser?.uid
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 21, green: 21, blue: 21, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        fetchUser()
        
    }
    
    fileprivate func fetchUser() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        //The FIRDatabase.database().reference() gives you access to the firebase database and once you call .child(users) you access to the child of the users of firebase 
        //Observe single event is just a fancy word to give me the username instead of observing the uid
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
             let username = dictionary["username"] as? String
            self.navigationItem.title = username
            
        }) { (err) in
            print("Failed to fetch user")
        }
    }
}
