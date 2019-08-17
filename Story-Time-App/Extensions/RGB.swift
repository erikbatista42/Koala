//
//  RGB.swift
//  Vlogr
//
//  Created by Erik Batista on 9/16/17.
//  Copyright © 2017 kennybatista. All rights reserved.
//

import Foundation
import UIKit

//Makes it easier to type rgb values
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
