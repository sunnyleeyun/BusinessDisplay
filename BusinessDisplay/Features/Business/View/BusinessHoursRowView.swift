//
//  BusinessHoursRowView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/13.
//

import SwiftUI

struct BusinessHoursRowView: View {
    var openingHours: PresentedOpeningHours

    var body: some View {
        HStack {
            Text(openingHours.day)
                .font(.system(size: 18, weight: openingHours.isBold ? .heavy : .regular))
                .foregroundColor(Color(hex: 0x333333))

            Spacer()

            Text(openingHours.hours)
                .font(.system(size: 18, weight: openingHours.isBold ? .heavy : .regular))
                .foregroundColor(Color(hex: 0x333333))
        }
        .padding(.vertical, 2)
    }
}
