//
//  Date.swift
//  Vlogr
//
//  Created by Erik Batista on 9/16/17.
//  Copyright © 2017 kennybatista. All rights reserved.
//

import Foundation

//This is to show how long ago you posted your post
extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = " just now"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = " minutes ago"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = " hours ago"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = " days ago"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = " weeks ago"
        } else {
            quotient = secondsAgo / month
            unit = " months ago"
        }
        
        return "\(quotient)\(unit)\(quotient == 1 ? "" : "")"
        
    }
}
