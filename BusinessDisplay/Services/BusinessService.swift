//
//  LocationService.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/11.
//

import Foundation

protocol BusinessFetching {
    func fetchLocation() async throws -> Business
}
