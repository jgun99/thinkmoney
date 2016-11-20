//
//  DateUtil.swift
//  thinkmoney
//
//  Created by ncsoft on 2015. 12. 18..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import SwiftDate

class DateUtil {
    

    static func getWeekDay(date:NSDate) -> String {
        var weekDay = ""
        
        switch date.weekday {
        case 1 :
            weekDay = "일"
        case 2:
            weekDay = "월"
        case 3:
            weekDay = "화"
        case 4:
            weekDay = "수"
        case 5:
            weekDay = "목"
        case 6:
            weekDay = "금"
        case 7:
            weekDay = "토"
        default:
            return ""
        }
        
        return weekDay
    }
}