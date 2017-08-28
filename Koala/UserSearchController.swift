//
//  UserSearchController.swift
//  Koala
//
//  Created by Erik Batista on 8/26/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import Foundation
import UIKit

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UISearchBarDelegate, UISearchDisplayDelegate {
    
    let cellId = "cellId"
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.barTintColor = UIColor.gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        sb.keyboardAppearance = .dark
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
    
    let searchUsersCV: UIView = {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth  = UIScreen.main.bounds.width
        
        let cv = SearchUsersCV(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
//        cv.collectionView?.bringSubview(toFront: )
//        cv.collectionView?.clipsToBounds = false
//        cv.collectionView?.register(UI, forCellWithReuseIdentifier: <#T##String#>)
        cv.bringSubview(toFront: cv)
        cv.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarAndSearchBar()
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileVideoCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(searchUsersCV)
        searchUsersCV.isHidden = true
        

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
