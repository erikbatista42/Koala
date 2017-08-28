//
//  SearchUsersTv.swift
//  Koala
//
//  Created by Erik Batista on 8/27/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import Foundation
import UIKit

class SearchUsersTv: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    var tableView = UITableView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupTv()
    }
    
    func setupTv() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.isUserInteractionEnabled = true
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.addSubview(tableView)
        bringSubview(toFront: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .gray
    
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
