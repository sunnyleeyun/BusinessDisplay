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
                    HStack {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text(viewModel.getStatus().label)
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: 0x333333))
                                
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

                    }
                    
                    
                    ForEach(viewModel.formattedOpeningHours(), id: \.self) { openingHours in
                        HStack {
                            Text(openingHours.day)
                                .font(.system(size: 18))
                                .foregroundColor(Color(hex: 0x333333))
                            Spacer()
                            Text(openingHours.hours)
                                .foregroundColor(Color(hex: 0x333333))
                        }
                        .padding(.vertical, 2)
                    }
                }
                // @TODO: Add bold, blur background radius, disclosure animation
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
                .background(.ultraThinMaterial)
//                .background(.ultraThick)
//                .background(Color(hex: 0xD9D9D9))
//                .blur(radius: 8)
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.5)) {
                        viewModel.isExpanded.toggle()
                    }
                }
                
                Spacer()
            }.padding(24)
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

