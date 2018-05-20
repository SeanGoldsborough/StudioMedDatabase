////
////  CalendarExtensions.swift
////  StudioMedDatabase
////
////  Created by Sean Goldsborough on 5/17/18.
////  Copyright © 2018 Sean Goldsborough. All rights reserved.
////
////Atakishiyev Orazdurdy tutorial 
//import Foundation
//import Foundation
//import UIKit
//
//extension Date {
//    
//    //period -> .WeekOfYear, .Day
//    func rangeOfPeriod(period: Calendar.Component) -> (Date, Date) {
//        
//        var startDate = Date()
//        var interval : TimeInterval = 0
//        let _ = Calendar.current.dateInterval(of: period, start: &startDate, interval: &interval, for: self)
//        let endDate = startDate.addingTimeInterval(interval - 1)
//        
//        return (startDate, endDate)
//    }
//    
//    func calcStartAndEndOfDay() -> (Date, Date) {
//        return rangeOfPeriod(period: .day)
//    }
//    
//    func calcStartAndEndOfWeek() -> (Date, Date) {
//        return rangeOfPeriod(period: .weekday)
//    }
//    
//    func calcStartAndEndOfMonth() -> (Date, Date) {
//        return rangeOfPeriod(period: .month)
//    }
//    
//    func getSpecificDate(interval: Int) -> Date {
//        var timeInterval = DateComponents()
//        timeInterval.day = interval
//        return Calendar.current.date(byAdding: timeInterval, to: self)!
//    }
//    
//    func getStart() -> Date {
//        let (start, _) = calcStartAndEndOfDay()
//        return start
//    }
//    
//    func getEnd() -> Date {
//        let (_, end) = calcStartAndEndOfDay()
//        return end
//    }
//    
//    func isBigger(to: Date) -> Bool {
//        return Calendar.current.compare(self, to: to, toGranularity: .day) == .orderedDescending ? true : false
//    }
//    
//    func isSmaller(to: Date) -> Bool {
//        return Calendar.current.compare(self, to: to, toGranularity: .day) == .orderedAscending ? true : false
//    }
//    
//    func isEqual(to: Date) -> Bool {
//        return Calendar.current.isDate(self, inSameDayAs: to)
//    }
//    
//    func isElement(of: [Date]) -> Bool {
//        for element in of {
//            if self.isEqual(to: element) {
//                return true
//            }
//        }
//        return false
//    }
//    
//    func getElement(of: [Date]) -> Date {
//        for element in of {
//            if self.isEqual(to: element) {
//                return element
//            }
//        }
//        return Date()
//    }
//    
//}
//
//extension UIColor {
//    
//    convenience init(hex: Int, alpha: CGFloat = 1.0) {
//        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
//        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
//        let blue = CGFloat((hex & 0xFF)) / 255.0
//        self.init(red:red, green:green, blue:blue, alpha:alpha)
//    }
//}

