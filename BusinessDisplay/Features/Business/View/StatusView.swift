//
//  StatusView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/13.
//

import SwiftUI

struct StatusView: View {
    @ObservedObject var viewModel: BusinessViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                HStack {
                    Text(viewModel.getStatus().label)
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: 0x333333))
                        .lineLimit(1)
                        .minimumScaleFactor(0.95)
                    
                    Circle()
                        .fill(viewModel.getStatusColor(viewModel.getStatus()))
                        .frame(width: 7, height: 7)
                }
                
                HStack {
                    Text("SEE FULL HOURS")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: 0x333333, opacity: 0.31))
                }
            }
            
            Spacer()
            
            Image("Accordion")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(hex: 0x333333))
                .rotationEffect(Angle(degrees: viewModel.isExpanded ? 90 : 0))
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.5)) {
                        viewModel.isExpanded.toggle()
                    }
                }
        }
    }
}
