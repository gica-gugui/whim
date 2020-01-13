//
//  DateExtensions.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Foundation

public extension Date {
    fileprivate static var generalDateFormatter: DateFormatter!
    fileprivate static var shortDateFormatter: DateFormatter!

    struct Format {
        public static let General = "yyyy-MM-dd'T'HH:mm:ssZ"
        public static let Short = "dd-MMMM-yyyy"
    }
    
    static func sharedGeneralDateFormatter() -> DateFormatter {
        if generalDateFormatter == nil {
            generalDateFormatter = DateFormatter()
            generalDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            generalDateFormatter.dateFormat = Format.General
        }
        
        return generalDateFormatter
    }
    
    static func shareShortDateFormatter() -> DateFormatter {
        if shortDateFormatter == nil {
            shortDateFormatter = DateFormatter()
            shortDateFormatter.dateFormat = Format.Short
            shortDateFormatter.locale = Locale(identifier: "RO")
        }
        
        return shortDateFormatter
    }
    
    func getGeneralDateDescription() -> String {
        let formatter = Date.sharedGeneralDateFormatter()
        return formatter.string(from: self)
    }
    
    func getShortDateDescription() -> String {
        let formatter = Date.shareShortDateFormatter()
        return formatter.string(from: self)
    }
    
    func generateRandomDate(daysBack: Int) -> Date? {
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
}
