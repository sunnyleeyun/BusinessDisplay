//
//  HomeView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/12.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = BusinessViewModel(businessFetching: BusinessService(networkManager: NetworkManager()))
    @State var subviewHeight : CGFloat = 0
    
    
    var body: some View {
        ZStack {
            splashImageBackground
            
            VStack() {
                Text(viewModel.business?.locationName ?? "")
                    .fontWeight(.bold)
                    .font(.system(size: 54))
                    .foregroundStyle(.white)
                    
                
                VStack {
                    VStack {
                        ForEach(viewModel.formattedOpeningHours(), id: \.self) { openingHours in
                            HStack {
                                Text(openingHours.day)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(openingHours.hours)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
                .onPreferenceChange(ViewHeightKey.self) { subviewHeight = $0 }
                .frame(height: viewModel.isExpanded ? subviewHeight : 50, alignment: .top)
                .padding()
                .clipped()
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .leading))
                .background(Color.gray.cornerRadius(10.0))
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.5)) {
                        viewModel.isExpanded.toggle()
                    }
                }
                
                Spacer()
            }
        }
        
        
        
        
    }
    
    private var splashImageBackground: some View {
        GeometryReader { geo in
            Image("Wallpaper")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .opacity(1)
        }
    }
    
}


struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

