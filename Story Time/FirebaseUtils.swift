//
//  FirebaseUtils.swift
//  Koala
//
//  Created by Erik Batista on 8/26/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import Foundation
import Firebase

//Fetches username for posts
extension FIRDatabase {
    static func fetchUserWithUid(uid: String, completion: @escaping (User) -> () ) {
                FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        }) { (error) in
            print("Failed to fetch username for posts :", error)
        }
    }
}
