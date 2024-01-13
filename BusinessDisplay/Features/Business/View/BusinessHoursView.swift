//
//  BusinessHoursView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/13.
//

import SwiftUI

struct BusinessHoursView: View {
    var viewModel: BusinessViewModel

    var body: some View {
        ForEach(viewModel.formattedOpeningHours(), id: \.self) { hours in
            BusinessHoursRowView(openingHours: hours)
        }
    }
}
