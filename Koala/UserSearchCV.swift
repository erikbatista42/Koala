//
//  SearchUsersCV.swift
//  Koala
//
//  Created by Erik Batista on 8/28/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import Foundation
import UIKit
import Firebase



class SearchUsersCV: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    func updateUsersView(_ users: [User]) {
        
        self.filteredUsers = users
        print(self.filteredUsers)
        self.collectionView.reloadData()
    }
    
    let cellId = "cellId"
    var collectionView: UICollectionView!
    
    let profileImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.backgroundColor = .magenta
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        
    }
    
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 111, height: 111)
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(UserSearchCVCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = UIColor.white
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceVertical = true
        self.addSubview(collectionView)
        
        
        fetchUsers()
    }
    var filteredUsers = [User]()
    var users = [User]()
    func fetchUsers() {
        
        let ref = FIRDatabase.database().reference().child("users")
        ref.observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            //For each iterates through every object in the dictioary
            dictionaries.forEach({ (key, value) in
                
                guard let userDictionary = value as? [String: Any] else { return}
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
                print(user.uid, user.username)
            })
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
            
        }) { (error) in
            print("failed to fetch users:", error)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        let numberOfUsers = UserSearchController.searchBar(users.count) //this would be nice but it doesn't let me it compiles an error with 'Instance member 'searchBar cannot be used on type 'UsersearchController' did you mean to use a value of this type instead?
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCVCell
        //        let filteredUsers = UserSearchController.searchBar(users.count)
        //        cell.user = filteredUsers[indexPath.item]
        
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width)
        return CGSize(width: width, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
