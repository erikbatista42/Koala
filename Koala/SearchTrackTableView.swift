//
//  SearchTrackTableView.swift
//  Koala
//
//  Created by Erik Batista on 7/9/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit



class SearchTrackTableView: UIViewController, UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate {
    
    //        UIColor.rgb(red: 210, green: 77, blue: 87, alpha: 1) Shoot a dance color
    //        UIColor.rgb(red: 254, green: 138, blue: 44, alpha: 1) SoundCloud color
    
    var soundCloudTracksSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.placeholder = "Search Soundcloud Tracks"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundColor = .white
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    func setupNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 210, green: 77, blue: 87, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "SoundCloud"
        navigationController?.navigationBar.tintColor = .white
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 102, green: 51, blue: 153, alpha: 1)
        
        setupNavBar()
        
        view.addSubview(soundCloudTracksSearchBar)
        soundCloudTracksSearchBar.delegate = self
        

    }
    
    
//    func searchBar(searchBar: UISearchBar, textDidChange textSearched: String) {
//        print(123)
//    }
}



