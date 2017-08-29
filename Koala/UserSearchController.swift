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

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UISearchBarDelegate, UISearchDisplayDelegate, MyViewDelegate {
    
    
    
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
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: .normal)
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 59, green: 89, blue: 152, alpha: 1)
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
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileVideoCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(searchUsersCV)
        searchUsersCV.isHidden = true
        fetchUsers()
        searchUsersCV.delegate = self
//        searchBar.delegate = self
//        let myView = searchUsersCV
//        myView.delegate = self
//        self.navigationController?.pushViewController(UserProfileController, animated: true)
    }
    
    
    func didTapButton() {
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
                (searchUsersCV.next as? UIViewController)?.navigationController?.pushViewController(userProfileController, animated: true)
        self.navigationController?.pushViewController(userProfileController, animated: true)
        self.searchBar.isHidden = true
        print("yo wassaup")
        
    }
    
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .purple
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
