//
//  HomeViewController.swift
//  Islamic Center App
//
//  Created by Ammar on 11/28/17.
//  Copyright © 2017 Mujadidia. All rights reserved.
//

import Foundation

public extension Date {

    public func getDateString(timeString: String, initialForamt: String, desiredFormat: String) -> String {
        
        guard !timeString.isEmpty || !initialForamt.isEmpty || !desiredFormat.isEmpty else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.dateFormat = initialForamt
        
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.dateFormat = desiredFormat
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    public func getDateString(format: String) -> String {
        
        guard !format.isEmpty else {
            return ""
        }
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }

    public func getDateString(format: String, timeZone: String) -> String {
        
        guard !format.isEmpty else {
            return ""
        }
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.init(abbreviation: timeZone)
        let dateString = dateFormatter.string(from: self)
        return dateString
    }

    
    public func getDateObject(timeString: String, format: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.date(from: timeString)!
    }
    
    public func dateTimeString(ofFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    public func getDateObject(timeString: String, format: String, timeZone: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.init(abbreviation: timeZone)
        return dateFormatter.date(from: timeString)!
    }
    
    public func getMyDate() -> String {
        let format = "yyyy-MM-dd HH:mm:ss z"
        let dateFormatter = DateFormatter.init()
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 5)
        dateFormatter.dateFormat = format
        
        let dateString = dateFormatter.string(from: self)
        //print("dateString: \(dateString)")
        
        let newDate = dateString.date(withFormat: format)

        let ndateFormatter = DateFormatter.init()
        ndateFormatter.timeZone = NSTimeZone.local
        ndateFormatter.dateFormat = format
        let ndateString = ndateFormatter.string(from: newDate!)
        //print("ndateString: \(ndateString)")

        return ndateString
    }
    
}

