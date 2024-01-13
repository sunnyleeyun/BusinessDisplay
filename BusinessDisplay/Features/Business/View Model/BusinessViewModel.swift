//
//  BusinessViewModel.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/11.
//

import Foundation
import SwiftUI

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
    
    func getStatus() -> OpeningStatus {
        guard let business = business else {
            return OpeningStatus(label: "Information Not Found", color: .RED)
        }
        return business.openStatus(from: getCurrentTimestamp())
    }
    
    func getStatusColor(_ status: OpeningStatus) -> Color {
        return status.color == .GREEN ? Color.green : status.color == .YELLOW ? Color.yellow : Color.red
    }
}
