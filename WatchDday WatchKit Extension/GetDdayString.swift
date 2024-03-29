//
//  GetDdayString.swift
//  WatchDday WatchKit Extension
//
//  Created by Seongheon Park on 2022/01/23.
//  Copyright © 2022 n30gu1. All rights reserved.
//

import Foundation

func calcDate(date: Date?) -> Int {
    let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
    return date!.totalDistance(from: today!, resultIn: .day)!
}

func getDdayString(dday: Dday?) -> String {
    if let dday = dday {
        if dday.startFromDayOne {
            return "D+\(calcDate(date: dday.date) + 1)"
        } else {
            if calcDate(date: dday.date) < 0 {
                return "D\(calcDate(date: dday.date))"
            } else if calcDate(date: dday.date) == 0 {
                return "D-Day"
            } else {
                return "D+\(calcDate(date: dday.date))"
            }
        }
    } else {
        return "None"
    }
}
