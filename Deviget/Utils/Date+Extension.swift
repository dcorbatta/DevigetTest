//
//  Date+Extension.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 15/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import Foundation
extension Date {
    func timeAgo() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: Date())
        var output = ""
        if let year = interval.year, year > 0 {
            output = (year == 1 ? "a year" : "\(year) years")
        } else if let month = interval.month, month > 0 {
            output = (month == 1 ? "a month" : "\(month) months")
        } else if let weekOfYear = interval.weekOfYear, weekOfYear > 0 {
            output = (weekOfYear == 1 ? "a week" : "\(weekOfYear) weeks")
        } else if let day = interval.day, day > 0 {
            output = (day == 1 ? "a day" : "\(day) days")
        } else if let hour = interval.hour, hour > 0 {
            output = (hour == 1 ? "a hour" : "\(hour) hours")
        } else if let minute = interval.minute, minute > 0 {
            output = (minute == 1 ? "a minute" : "\(minute) minutes")
        } else if let second = interval.second, second > 0 {
            output = (second == 1 ? "a second" : "\(second) seconds")
        } else {
            output = "a moment"
        }
        return output + " ago"
    }
}
