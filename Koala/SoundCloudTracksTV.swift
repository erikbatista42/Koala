//
//  SoundCloudTracks.swift
//  Koala
//
//  Created by Erik Batista on 7/10/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit

class SoundCloudTracksTV: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "CellId"
    let array = ["123", "you a hoe", "lmao"]
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
    }()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        
        super.init(frame: frame, style: .plain)
        backgroundColor = .blue
        self.delegate = self
        self.dataSource = self
        register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
//        addSubview(imageView)
//        imageView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 0, width: 50, height: 50)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = array[indexPath.row]
        
        cell.imageView?.image = #imageLiteral(resourceName: "record_unselected")
        cell.imageView?.backgroundColor = .magenta
        
        return cell
    }

}
