//
//  StubBusinessModel.swift
//  BusinessDisplayTests
//
//  Created by 李昀 on 2024/1/13.
//

import Foundation

final class StubBusinessModel {
    func getBusiness() throws -> Business {
        let jsonData = jsonString.data(using: .utf8)!
        return try JSONDecoder().decode(Business.self, from: jsonData)
    }
    
    let jsonString = """
    {
        "location_name": "BEASTRO by Marshawn Lynch",
        "hours": [
            {
                "day_of_week": "WED",
                "start_local_time": "07:00:00",
                "end_local_time": "13:00:00"
            },
            {
                "day_of_week": "WED",
                "start_local_time": "15:00:00",
                "end_local_time": "22:00:00"
            },
            {
                "day_of_week": "SAT",
                "start_local_time": "10:00:00",
                "end_local_time": "24:00:00"
            },
            {
                "day_of_week": "SUN",
                "start_local_time": "00:00:00",
                "end_local_time": "02:00:00"
            },
            {
                "day_of_week": "SUN",
                "start_local_time": "10:30:00",
                "end_local_time": "21:00:00"
            },
            {
                "day_of_week": "TUE",
                "start_local_time": "07:00:00",
                "end_local_time": "13:00:00"
            },
            {
                "day_of_week": "TUE",
                "start_local_time": "15:00:00",
                "end_local_time": "22:00:00"
            },
            {
                "day_of_week": "THU",
                "start_local_time": "00:00:00",
                "end_local_time": "24:00:00"
            },
            {
                "day_of_week": "FRI",
                "start_local_time": "07:00:00",
                "end_local_time": "24:00:00"
            }
        ]
    }
    """

}
