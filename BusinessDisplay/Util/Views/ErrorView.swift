//
//  ErrorView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/13.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            Text("Error loading data")
                .font(.headline)
                .foregroundColor(.red)
                .padding()
        }
    }
}

#Preview {
    ErrorView()
}
