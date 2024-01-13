//
//  LoadingView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/12.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Background blur effect
            Color.black.opacity(0.5)
            
            // Progress view with tint color
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .padding()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    LoadingView()
}
