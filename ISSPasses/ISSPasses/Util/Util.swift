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
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func getFormatedTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm:ss a"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
}
