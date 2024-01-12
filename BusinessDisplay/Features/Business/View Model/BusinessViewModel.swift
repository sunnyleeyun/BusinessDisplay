//
//  BusinessViewModel.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/11.
//

import Foundation

class BusinessViewModel: ObservableObject {
    let timestamp = Date()
    
    @Published internal var business: Business? = nil
    
    @Published var status: String = "Status"
    @Published var isExpanded: Bool = false
    
    private var businessService: BusinessFetching
    init(businessFetching: BusinessFetching) {
        self.businessService = businessFetching
        Task {
            await getBusiness()
        }
    }
    
    func getBusiness() async {
        do {
            let business = try await businessService.fetchLocation()
            DispatchQueue.main.async {
                self.business = business
            }
        } catch {
            debugPrint("Error getBusiness \(error)")
        }
    }
    
    func formattedOpeningHours() -> [PresentedOpeningHours] {
        return business?.formattedOpeningHours(from: getCurrentTimestamp()) ?? []
    }
    
    private func getCurrentTimestamp() -> Int {
        let currentDateTime = Date()
        let timestamp = Int(currentDateTime.timeIntervalSince1970)
        return timestamp
    }
    
}
