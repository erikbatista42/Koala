//
//  UserProfileHeader.swift
//  Koala
//
//  Created by Erik Batista on 7/7/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        
         profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    var user: User? {
        didSet {
            setUpProfileImage()
        }
    }
    
    fileprivate func setUpProfileImage() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        //The FIRDatabase.database().reference() gives you access to the firebase database and once you call .child(users) you access to the child of the users of firebase
        //Observe single event is just a fancy word to give me the username instead of observing the uid
        guard let profileImageUrl = user?.profileImageUrl else { return }
        
        guard  let url = URL(string: profileImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check the err
            
            if let err = err {
                print("Failed to fetch profile image", err)
                return
            }
            
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
