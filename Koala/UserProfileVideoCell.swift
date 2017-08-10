//
//  MainCVCell.swift
//  Koala
//
//  Created by Erik on 7/31/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit

class UserProfileVideoCell: UICollectionViewCell {
    
    
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    var video: Post? {
        didSet {
            guard let videoUrl = video?.videoUrl else { return }
            thumbNailImageView.loadImageUrl(UrlString: videoUrl)
            
            guard let url = URL(string: videoUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print("Failed to fetch Video:", err)
                    return
                }
                guard let videoData = data else { return }
                
                let thumbNailImage = UIImage(data: videoData)
                
                DispatchQueue.main.async {
                    self.thumbNailImageView.image = thumbNailImage
                }
            }.resume()
        }
    }
    
    let thumbNailImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = UIColor.green
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(thumbNailImageView)
        thumbNailImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
