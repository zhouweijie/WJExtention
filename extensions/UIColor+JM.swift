//
//  UIColor+JM.swift
//  news
//
//  Created by zhouweijie on 2018/12/16.
//  Copyright © 2018 malei. All rights reserved.
//

import Foundation


extension UIColor {
    class func hex(hexValue:uint) -> UIColor {
        return UIColor(red: (CGFloat((hexValue & 0xFF0000 )>>16))/255.0, green: (CGFloat((hexValue & 0x00FF00 )>>8))/255.0, blue: (CGFloat(hexValue & 0x0000FF))/255.0, alpha: 1.0)
    }
}
