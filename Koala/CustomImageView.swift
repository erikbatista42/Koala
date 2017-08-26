//
//  CustomImageView.swift
//  Koala
//
//  Created by Erik on 8/8/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit


var imageCache = [String : UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(UrlString: String) {
        lastURLUsedToLoadImage = UrlString
        
        
        if let cachedImage = imageCache[UrlString] {
            self.image = cachedImage
        }
        
        
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
            
            imageCache[url.absoluteString] = thumbNailImage
            
            DispatchQueue.main.async {
                self.image = thumbNailImage
            }
            }.resume()

    }
}
