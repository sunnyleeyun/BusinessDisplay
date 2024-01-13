//
//  HomeView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/12.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = BusinessViewModel(businessFetching: BusinessService(networkManager: NetworkManager()))
    @State var subviewHeight: CGFloat = 0
    
    
    var body: some View {
        ZStack {
            SplashBackgroundView()
            switch viewModel.viewStatus {
            case .isLoading:
                LoadingView()
            case .isError:
                ErrorView()
            case .isLoaded:
                 BusinessDetailsView(viewModel: viewModel, subviewHeight: $subviewHeight)                
            }
        }
        
    }
    
}


struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = value + nextValue()
    }
}
