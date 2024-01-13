//
//  ViewMenuView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/13.
//

import SwiftUI

struct ViewMenuView: View {
    @ObservedObject var viewModel: BusinessViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: -5) {
                Image("Accordion")
                    .resizable()
                    .frame(width: 15, height: 20)
                    .foregroundColor(Color(hex: 0xFFFFFF, opacity: 0.5))
                    .rotationEffect(Angle(degrees: 270))

                Image("Accordion")
                    .resizable()
                    .frame(width: 15, height: 20)
                    .foregroundColor(Color(hex: 0xFFFFFF))
                    .rotationEffect(Angle(degrees: 270))
            }

            Text("View Menu")
                .foregroundColor(.white)
                .font(.system(size: 24))
        }
        .opacity(viewModel.isExpanded ? 0 : 1)
    }
}
