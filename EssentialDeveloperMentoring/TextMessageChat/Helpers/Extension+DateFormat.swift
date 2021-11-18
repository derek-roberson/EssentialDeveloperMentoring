//
//  Extension+DateFormat.swift
//  EssentialDeveloperMentoring
//
//  Created by Derek Roberson on 11/17/21.
//

import Foundation

extension Date {
    func string(with format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    static func dateWithFormat(_ str: String?, convertServerTimeZone: Bool = false) -> Date?{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if(convertServerTimeZone){
            formatter.timeZone = TimeZone(identifier: "US/Central")
        }
        guard let string = str else{
            return nil
        }
        let formats = ["yyyy-MM-dd'T'HH:mm:ss.SS", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss.SSS", "yyyy-MM-dd'T'HH:mm:ssZ"]
        for format in formats{
            formatter.dateFormat = format
            if let date = formatter.date(from: string){
                return date
            }
        }
        NSLog("Date string \(string) does not match a known format")
        return nil
    }
}
