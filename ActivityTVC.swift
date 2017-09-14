//
//  ActivityTVC.swift
//  Koala
//
//  Created by Erik Batista on 9/13/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import Foundation
import UIKit

class ActivityTVC: UITableViewController {
    
    let cellId = "CellId"
    let array = ["Aaran", "Aaren", "Aarez", "Aarman", "Aaron", "Aaron-James", "Aarron", "Aaryan"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(100)
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = array[indexPath.row]
        
        cell.imageView?.image = #imageLiteral(resourceName: "record_unselected")
        cell.imageView?.backgroundColor = .magenta
        
        return cell
    }
}
