//
//  HomeView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/12.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = BusinessViewModel(businessFetching: BusinessService(networkManager: NetworkManager()))
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1)
                
            }
        }
    }
}

#Preview {
    HomeView()
}
