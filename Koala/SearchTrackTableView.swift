//
//  SearchTrackTableView.swift
//  Koala
//
//  Created by Erik Batista on 7/9/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit



class SearchTrackTableView: UIViewController, UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate {
    
    var searchfar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var searchBar:UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.placeholder = " Search Soundcloud Tracks"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
//        navigationItem.titleView = searchBar
        view.addSubview(searchBar)
        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 249, green: 105, blue: 14, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        view.backgroundColor = UIColor.rgb(red: 102, green: 51, blue: 153, alpha: 1)
        
//        view.addSubview(searchBar)

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange textSearched: String) {
        print(123)
    }
}



