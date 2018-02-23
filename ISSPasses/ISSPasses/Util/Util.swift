//
//  Util.swift
//  ISSPasses
//
//  Created by Balamurugan Gopal on 2/17/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//

import Foundation

class Util {
    
    class func getFormatedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    class func getFormatedTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm:ss a"
        let time = dateFormatter.string(from: date)
        return time
    }
    
}
