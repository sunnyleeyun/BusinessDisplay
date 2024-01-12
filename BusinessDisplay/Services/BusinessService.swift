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

class BusinessService: BusinessFetching {
    private var networkManager: NetworkManager
    private let baseUrl = "https://purs-demo-bucket-test.s3.us-west-2.amazonaws.com"
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchLocation() async throws -> Business {
        guard let url = URL(string: "\(baseUrl)/location.json") else {
            fatalError("Invalid Url")
        }
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.request(fromUrl: url, httpMethod: .get) { (result: Result<Business, Error>) in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
