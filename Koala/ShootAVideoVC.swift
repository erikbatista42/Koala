//
//  SearchTrackTableView.swift
//  Koala
//
//  Created by Erik Batista on 7/9/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
//import Alamofire


//class ShootAVideoViewController: UIViewController, UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate {
//    
//    //        UIColor.rgb(red: 210, green: 77, blue: 87, alpha: 1) Shoot a dance color
//    //        UIColor.rgb(red: 254, green: 138, blue: 44, alpha: 1) SoundCloud color
//    
//    
//    var searchTracksSearchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.searchBarStyle = UISearchBarStyle.default
//        searchBar.placeholder = "Search Tracks"
//        searchBar.sizeToFit()
//        searchBar.isTranslucent = true
//        searchBar.backgroundColor = .white
//        
//        
//        return searchBar
//    }()
//    
//    func setupNavBar() {
//        self.navigationItem.title = "iTunes"
//        let nav = self.navigationController?.navigationBar
//        nav?.barTintColor = UIColor.rgb(red: 245, green: 50, blue: 97, alpha: 1)
//        nav?.tintColor = .white
//        nav?.isTranslucent = false
//        nav?.barStyle = UIBarStyle.black
//        nav?.tintColor = UIColor.white
//        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(handleCancel))
//    }
//    
//    @objc func handleCancel() {dismiss(animated: true, completion: nil)}
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.rgb(red: 102, green: 51, blue: 153, alpha: 1)
//        
//        setupNavBar()
//        
//        view.addSubview(searchTracksSearchBar)
//        searchTracksSearchBar.delegate = self
//
//        let tableView = SearchTracksTV()
//        self.view.addSubview(tableView)
//        tableView.anchor(top: searchTracksSearchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
//        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: .normal)
//         var prefersStatusBarHidden: Bool {
//            return true
//        }
//    }
//    
//    
//func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {searchBar.setShowsCancelButton(true, animated: true)}
//func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {searchBar.setShowsCancelButton(true, animated: true)}
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.setShowsCancelButton(false, animated: true)
//    }
//    
//}
//
//
//
