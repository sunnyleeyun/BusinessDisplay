//
//  Business.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/11.
//

import Foundation

struct Business: Decodable {
    let locationName: String
    let hours: [Hour]
    
    enum CodingKeys: String, CodingKey {
        case locationName = "location_name"
        case hours
    }
}

struct Hour: Decodable {
    let dayOfWeek: String
    let startLocalTime: String
    let endLocalTime: String
    
    enum CodingKeys: String, CodingKey {
        case dayOfWeek = "day_of_week"
        case startLocalTime = "start_local_time"
        case endLocalTime = "end_local_time"
    }
}
