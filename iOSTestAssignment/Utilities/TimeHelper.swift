//
//  TimeHelper.swift
//  iOSTestAssignment
//
//  Created by Surendra Singh on 01/05/24.
//

import Foundation

struct TimerHelper {
    static func getTimeTaken(startDate:Date, endDate: Date) -> Double {
        return endDate.timeIntervalSince(startDate) * 1000
    }
}
