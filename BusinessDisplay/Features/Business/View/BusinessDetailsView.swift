//
//  BusinessDetailsView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/13.
//

import SwiftUI

struct BusinessDetailsView: View {
    @ObservedObject var viewModel: BusinessViewModel
    @Binding var subviewHeight: CGFloat

    var body: some View {
        VStack() {
            LocationNameView(viewModel: viewModel)
            
            VStack {
                StatusView(viewModel: viewModel)
                CustomDivider()
                BusinessHoursView(viewModel: viewModel)
            }
            .background(GeometryReader {
                Color.clear.preference(key: ViewHeightKey.self,
                                       value: $0.frame(in: .local).size.height)
            })
            .onPreferenceChange(ViewHeightKey.self) { subviewHeight = $0 }
            .frame(height: viewModel.isExpanded ? subviewHeight : 36, alignment: .top)
            .padding()
            .clipped()
            .frame(maxWidth: .infinity)
            .transition(.move(edge: .leading))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.thinMaterial)
            )
            
            Spacer()
            ViewMenuView(viewModel: viewModel)
        }.padding(.horizontal, 24)
    }
}


