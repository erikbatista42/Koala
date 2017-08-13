//
//  CustomImageView.swift
//  Koala
//
//  Created by Erik on 8/8/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(UrlString: String) {
        lastURLUsedToLoadImage = UrlString
        guard let url = URL(string: UrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch thumbnail:", err)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let thumbnailData = data else { return }
            
            let thumbNailImage = UIImage(data: thumbnailData)
            
            DispatchQueue.main.async {
                self.image = thumbNailImage
            }
            }.resume()

    }
}
