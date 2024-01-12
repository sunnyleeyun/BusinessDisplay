//
//  BusinessViewModel.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/11.
//

import Foundation

class BusinessViewModel: ObservableObject {
    internal var business: Business? = nil
    
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
            self.business = business
        } catch {
            debugPrint("Error getBusiness \(error)")
        }
    }
}
