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
    let thumbnailUrl: String
    init(dictionary: [String: Any]) {
        self.videoUrl = dictionary["videoUrl"] as? String ?? ""
        self.thumbnailUrl = dictionary["thumbnailUrl"] as? String ?? ""
    }
}
