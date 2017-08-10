//
//  HomePostCell.swift
//  Koala
//
//  Created by Erik on 8/7/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
//import AVKit
//import AVFoundation
//import Player

class HomePostCell: UICollectionViewCell {
    
    //Thumbnail generator
//    func getThumbnailImage(forUrl url: URL) -> UIImage? {
//        let asset: AVAsset = AVAsset(url: url)
//        let imageGenerator = AVAssetImageGenerator(asset: asset)
//        
//        do {
//            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
//            return UIImage(cgImage: thumbnailImage)
//        } catch let error {
//            print(error)
//        }
//        
//        return nil
//    }
    
    var post: Post? {
        didSet {
            print(post?.videoUrl)
//            photoImageView.load
        }
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        return iv
    }()
//    let thumbNailImageView: CustomImageView = {
//        let iv = CustomImageView()
//        iv.backgroundColor = UIColor.green
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.contentMode = UIViewContentMode.scaleAspectFill
//        iv.layer.masksToBounds = true
//        return iv
//    }()

    
        override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
//            self.addSubview(thumbNailImageView)
//            thumbNailImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
