//
//  Videos.swift
//  Koala
//
//  Created by Erik on 8/6/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import Foundation

struct Post {
    let videoUrl: String
//    let videoThumbnailUrl: String
    init(dictionary: [String: Any]) {
        self.videoUrl = dictionary["videoUrl"] as? String ?? ""
//        self.videoThumbnailUrl = dictionary["videoThumbnailUrl"] as? String ?? ""
    }
}
