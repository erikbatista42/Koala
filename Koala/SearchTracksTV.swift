//
//  SoundCloudTracks.swift
//  Koala
//
//  Created by Erik Batista on 7/10/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Alamofire

class SearchTracksTV: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "CellId"
    let array = ["1", "2", "3"]
    
    
    
    
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
        
        alamofireGet()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func alamofireGet() {
        guard var url = URL(string: "https://soundcloud.com/connect+client_id") else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "Get"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { (response, data, error) in
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
        }
       
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
