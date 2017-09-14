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
    
    var searchURL = "https://api.spotify.com/v1/search?q=jax+jones&type=track,artist&market=US"
    let token = "BQAL5DQILSJL1BWbSVXGtcdl3I_o1pnPWrIYhL555g462Icn9PzZfQ1hK13SFe3DMf0lUGbtcVBbvOzwJRuKkDBZfJdOSMnrVeAeEkma67qk0aeClpH4vVUtH4mSuCVUTSUaN3X0cbOxVGpZxe0s4Or9ahmMrZFZeE7Z8tU6lsYN72kYg5xZMHSbsw2oyF4fyVZS7ifdFO_K3NLfCaZgFKqJcR_YaGLuYXhXXqDfAhhbcznXTS6gb4Hoi4vLX-p45-rh8oEO_VjMZJ6fZ1yrwXzWs-ZT8vCY16nHi5xgIrBthiW5PgT9t7VkXoYV0RgYZsaDm3pf"
    typealias JSONStandard = [String: AnyObject]
    
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
        
        callAlamo(url: searchURL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func callAlamo(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            
            self.parseData(JSONData: response.data!)
            
        })
    }
    
    func parseData(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as? JSONStandard
            print(readableJSON ?? "")
        } catch {
            print(error)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    

}
