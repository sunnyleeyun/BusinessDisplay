//
//  Business.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/11.
//

import Foundation

enum Case {
    case UPPER
    case LOWER
}

struct OpeningStatus {
    let label: String
    let color: OpeningColorStatus
}

enum OpeningColorStatus {
    case GREEN
    case YELLOW
    case RED
}

struct Business: Codable {
    let locationName: String
    let hours: [Hour]
    
    enum CodingKeys: String, CodingKey {
        case locationName = "location_name"
        case hours
    }
    
    func openingHours() -> [(DayOfWeek, [TimeSlot])] {
        var result: [(DayOfWeek, [TimeSlot])] = []
        
        // Add all 7 days
        for day in DayOfWeek.allCases {
            result.append((day, []))
        }
        
        // Add hour to each day
        for hour in hours {
            // Extract start and end time components
            guard let dayOfWeek = DayOfWeek(rawValue: hour.dayOfWeek),
                  let startTimeComponents = extractTimeComponents(from: hour.startLocalTime),
                  let endTimeComponents = extractTimeComponents(from: hour.endLocalTime) else {
                continue
            }
            
            // Calculate start and end times in minutes
            let start = calculateMinutes(hour: startTimeComponents.hour, minute: startTimeComponents.minute, second: startTimeComponents.second)
            let end = calculateMinutes(hour: endTimeComponents.hour, minute: endTimeComponents.minute, second: endTimeComponents.second)
            
            // Create a TimeSlot instance
            let timeSlot = TimeSlot(start: start, end: end)
            
            // Find the index of the day in the result and append the timeSlot
            if let index = result.firstIndex(where: { $0.0 == dayOfWeek }) {
                result[index].1.append(timeSlot)
            }
        }
        
        // Sort time slots based on starting hours
        for index in result.indices {
            result[index].1.sort(by: { $0.start < $1.start })
        }
        
        return result
    }
    
    
    enum BusinessStatus {
        case openUntil(String)
        case openUntilReopens(String, String)
        case opensAgainAt(String)
        case opens(String, String)
    }
    
    // Method to generate open text based on the current timestamp
    func openStatus(from currentTimestamp: Int, periodCase: Case = .UPPER) -> OpeningStatus {
        let openingHours = openingHours()
        if openingHours.count != 7 {
            fatalError("Opening Hours Mapping Issue")
        }
        
        let now = currentTimestamp
        let nowDayIdx = adjustedCurrentDay(from: now)
        let nowMinutes = getCurrentTimestampInMinutes(from: now)
        
        let status = getStatus(openingHours: openingHours, nowDayIdx: nowDayIdx, nowMinutes: nowMinutes, periodCase: periodCase)
        
        switch status {
        case .openUntil(let convertedTime):
            return OpeningStatus(label: "Open until \(convertedTime)", color: .GREEN)
        case .openUntilReopens(let convertedTime, let nextConvertedTime):
            return OpeningStatus(label: "Open until \(convertedTime), reopens at \(nextConvertedTime)", color: .YELLOW)
        case .opensAgainAt(let nextConvertedTime):
            return OpeningStatus(label: "Opens again at \(nextConvertedTime)", color: .RED)
        case .opens(let nextDay, let nextConvertedTime):
            return OpeningStatus(label: "Opens \(nextDay) \(nextConvertedTime)", color: .RED)
        }
    }
    
    func formattedOpeningHours(from currentTimestamp: Int) -> [PresentedOpeningHours] {
        let openingHours = openingHours()
        var formattedHours: [PresentedOpeningHours] = []

        for (day, timeSlots) in openingHours {
            if timeSlots.isEmpty {
                formattedHours.append(PresentedOpeningHours(day: day.fullName, hours: "Closed", isBold: false))
                continue
            }

            for timeSlot in timeSlots {
                let previousEntry = formattedHours.last

                let dayString: String
                if let previousDay = previousEntry?.day, previousDay == day.fullName {
                    dayString = ""
                } else {
                    dayString = day.fullName
                }
                let isBold = isCurrentTimestampWithinTimeSlot(currentTimestamp: currentTimestamp, day: day, timeSlot: timeSlot)
                if (isOpen24Hours(timeSlot)) {
                    formattedHours.append(PresentedOpeningHours(day: dayString, hours: "Open 24hrs", isBold: isBold))
                } else {
                    let formattedTime = formatTimeSlot(timeSlot, .LOWER)
                    formattedHours.append(PresentedOpeningHours(day: dayString, hours: formattedTime, isBold: isBold))
                }
            }
        }

        return formattedHours
    }
    
    
}

extension Business {
    private func isOpen24Hours(_ timeSlot: TimeSlot) -> Bool {
        return timeSlot.start == 0 && timeSlot.end == 1440
    }
    private func isCurrentTimestampWithinTimeSlot(currentTimestamp: Int, day: DayOfWeek, timeSlot: TimeSlot) -> Bool {
        let now = currentTimestamp
        let nowDayOfWeek = getDayOfWeek(from: currentTimestamp)
        let nowMinutes = getCurrentTimestampInMinutes(from: now)
        // if not the same day, return false (not bold)
        if (nowDayOfWeek != day) {
            return false
        }
        // if the same day, check within time range
        return nowMinutes >= timeSlot.start && nowMinutes < timeSlot.end
    }
    
    private func getDayOfWeek(from currentTimestamp: Int) -> DayOfWeek {
        let nowDayIdx = adjustedCurrentDay(from: currentTimestamp)
        let consecutiveDays: [DayOfWeek] = [.MON, .TUE, .WED, .THU, .FRI, .SAT, .SUN]
        return consecutiveDays[nowDayIdx]
    }
    
    private func getStatus(openingHours: [(DayOfWeek, [TimeSlot])], nowDayIdx: Int, nowMinutes: Int, periodCase: Case = .UPPER) -> BusinessStatus {
        
        // Find the current day's time slots
        let todayOpeningTimes = openingHours[nowDayIdx].1
        
        // Find next open day
        let nextOpenDayIdx = findNextOpenDayIdx(from: openingHours, startingFrom: (day: nowDayIdx, currTimeInMin: nowMinutes))
        let (nextDay, nextDayOpeningTimes) = openingHours[nextOpenDayIdx]
        let nextDayConvertedStartTime = convertMinutesToTime(nextDayOpeningTimes.first?.start, periodCase)
        
        // Find the current opening time, and now is within the time slot
        if let currentOpeningTime = todayOpeningTimes.first(where: { nowMinutes >= $0.start && nowMinutes < $0.end }) {
            // Calculate the remaining time until the current slot ends
            let remainingTime = currentOpeningTime.end - nowMinutes
            let convertedEndTime = convertMinutesToTime(currentOpeningTime.end, periodCase)
            
            if remainingTime > 60 {
                // If there's more than an hour remaining, simply mention the current slot's end time
                return .openUntil(convertedEndTime)
            } else {
                // If there's less than an hour remaining, also mention the next slot's start time
                return .openUntilReopens(convertedEndTime, nextDayConvertedStartTime)
            }
        }
        
        // Now not open
        let consecutiveDays: [DayOfWeek] = [.MON, .TUE, .WED, .THU, .FRI, .SAT, .SUN]
        let expectedNextDay = consecutiveDays[(nowDayIdx + 1) % 7]
        if nextOpenDayIdx == nowDayIdx, let nextOpeningTime = nextDayOpeningTimes.first(where: { $0.start > nowMinutes }) {
            let todayNextConvertedStartTime = convertMinutesToTime(nextOpeningTime.start, periodCase)
            return .opensAgainAt(todayNextConvertedStartTime)
        } else if nextDay != expectedNextDay && nextDayOpeningTimes.first!.start > nowMinutes {
            return .opensAgainAt(nextDayConvertedStartTime)
        } else {
            return .opens(nextDay.fullName, nextDayConvertedStartTime)
        }
    }
    
    /// Calculates the adjusted current day of the week, starting from Monday as 0.
    /// - Parameter timestamp: The timestamp for which to calculate the adjusted current day.
    /// - Returns: Adjusted current day of the week (0 for Monday, 1 for Tuesday, ..., 6 for Sunday).
    private func adjustedCurrentDay(from timestamp: Int) -> Int {
        let currentDay = Calendar.current.component(.weekday, from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
        return (currentDay + 5) % 7
    }
    
    private func formatTimeSlot(_ timeSlot: TimeSlot, _ periodCase: Case = .UPPER) -> String {
        let startTime = convertMinutesToTime(timeSlot.start, .LOWER)
        let endTime = convertMinutesToTime(timeSlot.end, .LOWER)
        return "\(startTime)-\(endTime)"
    }
    
    private func convertMinutesToTime(_ minutes: Int?, _ periodCase: Case = .UPPER) -> String {
        guard let minutes = minutes else {
            return ""
        }
        let hours = minutes / 60
        let remainderMinutes = minutes % 60
        
        let format = getTimeFormat(for: hours, remainderMinutes: remainderMinutes)
        let dateComponents = DateComponents(hour: hours, minute: remainderMinutes)

        guard let date = Calendar.current.date(from: dateComponents) else {
            return "Invalid Time"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format

        let formattedTime = formatter.string(from: date)

        switch periodCase {
        case .LOWER:
            return formattedTime.lowercased()
        case .UPPER:
            return formattedTime.uppercased()
        }
    }
    // Helper method to calculate current timestamp in minutes
    private func getCurrentTimestampInMinutes(from timestamp: Int) -> Int {
        let nowComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
        return calculateMinutes(hour: nowComponents.hour ?? 0, minute: nowComponents.minute ?? 0, second: nowComponents.second ?? 0)
    }
    
    // Helper method to calculate minutes from time components
    private func calculateMinutes(hour: Int, minute: Int, second: Int) -> Int {
        return hour * 60 + minute + (second > 0 ? 1 : 0)
    }
    
    private func findNextOpenDayIdx(from openingHours: [(DayOfWeek, [TimeSlot])], startingFrom startInfo: (day: Int, currTimeInMin: Int)) -> Int {
        let dayCount = DayOfWeek.allCases.count
        
        // Check if there are more time slots for the current day
        if openingHours[startInfo.day].1.first(where: { $0.start > startInfo.currTimeInMin }) != nil {
            return startInfo.day
        }
        
        // Iterate through the days to find the next available time slots
        for nextIndex in (startInfo.day + 1)..<(startInfo.day + 1 + dayCount) {
            // Use modulo to cycle through the days
            let nextDaySlots = openingHours[nextIndex % dayCount].1
            if !nextDaySlots.isEmpty {
                return nextIndex % dayCount
            }
        }
        
        // If no valid time slots found, return the current index
        return startInfo.day
    }
    
    private func getTimeFormat(for hours: Int, remainderMinutes: Int) -> String {
        if hours < 10 || (hours > 12 && hours < 22) {
            if (remainderMinutes == 0) {
                return "ha"
            } else {
                return "h:mma"
            }
        } else {
            if (remainderMinutes == 0) {
                return "hha"
            } else {
                return "hh:mma"
            }
        }
    }
    
    // Helper method to extract time components from a time string
    private func extractTimeComponents(from timeString: String) -> (hour: Int, minute: Int, second: Int)? {
        let components = timeString.components(separatedBy: ":")
        
        guard components.count == 3,
              let hour = Int(components[0]),
              let minute = Int(components[1]),
              let second = Int(components[2]) else {
            return nil
        }
        
        return (hour, minute, second)
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
    let start: Int
    let end: Int
}

struct PresentedOpeningHours: Hashable, Identifiable {
    let id = UUID()
    let day: String
    let hours: String
    let isBold: Bool
}

enum DayOfWeek: String, CaseIterable, Codable {
    case MON
    case TUE
    case WED
    case THU
    case FRI
    case SAT
    case SUN
    
    var fullName: String {
        switch self {
        case .MON: return "Monday"
        case .TUE: return "Tuesday"
        case .WED: return "Wednesday"
        case .THU: return "Thursday"
        case .FRI: return "Friday"
        case .SAT: return "Saturday"
        case .SUN: return "Sunday"
        }
    }
}
