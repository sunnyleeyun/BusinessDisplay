//
//  Business.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/11.
//

import Foundation

struct Business: Codable {
    let locationName: String
    let hours: [Hour]

    enum CodingKeys: String, CodingKey {
        case locationName = "location_name"
        case hours
    }
    
    func openingHours() -> [(DayOfWeek, [TimeSlot])] {
        var result: [(DayOfWeek, [TimeSlot])] = []

        for day in DayOfWeek.allCases {
            result.append((day, []))
        }
        
        for hour in hours {
            guard let dayOfWeek = DayOfWeek(rawValue: hour.dayOfWeek) else {
                continue
            }

            let timeSlot = TimeSlot(start: hour.startLocalTime, end: hour.endLocalTime)
            if let index = result.firstIndex(where: { $0.0 == dayOfWeek }) {
                result[index].1.append(timeSlot)
            }
        }
        return result

    }
}

struct Hour: Codable {
    let dayOfWeek: String
    let startLocalTime: String
    let endLocalTime: String
    
    enum CodingKeys: String, CodingKey {
        case dayOfWeek = "day_of_week"
        case startLocalTime = "start_local_time"
        case endLocalTime = "end_local_time"
    }
    
}

struct TimeSlot {
    let start: String
    let end: String
}
enum DayOfWeek: String, CaseIterable, Codable {
    case MON
    case TUE
    case WED
    case THU
    case FRI
    case SAT
    case SUN
}
