//
//  UserSearchController.swift
//  Koala
//
//  Created by Erik Batista on 8/26/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import Foundation
import UIKit

class UserSearchController: UICollectionViewController,UISearchBarDelegate, UISearchDisplayDelegate {
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.barTintColor = UIColor.gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
//        sb.showsCancelButton = false
        return sb
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: .normal)
        
        collectionView?.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 59, green: 89, blue: 152, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {searchBar.setShowsCancelButton(true, animated: true)}
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {searchBar.setShowsCancelButton(true, animated: true)}
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
    }

}
