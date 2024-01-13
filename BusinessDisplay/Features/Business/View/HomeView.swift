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
            switch viewModel.viewStatus {
            case .isLoading:
                LoadingView()
            case .isError:
                ErrorView()
                
            case .isLoaded:
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
                        
                        Divider()
                            .frame(height: 0.5)
                            .background(Color.gray)
                            .padding(.top, 4)
                        
                        ForEach(viewModel.formattedOpeningHours(), id: \.self) { openingHours in
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

                }.padding(.horizontal, 24)
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

