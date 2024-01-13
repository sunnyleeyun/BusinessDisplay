//
//  LocationNameView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/13.
//

import SwiftUI

struct LocationNameView: View {
    @ObservedObject var viewModel: BusinessViewModel

    var body: some View {
        Text(viewModel.business?.locationName ?? "")
            .fontWeight(.bold)
            .font(.system(size: 54))
            .foregroundStyle(.white)
    }
}
