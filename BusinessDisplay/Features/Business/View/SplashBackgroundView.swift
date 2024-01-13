//
//  SplashBackgroundView.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/13.
//

import SwiftUI

struct SplashBackgroundView: View {
    var body: some View {
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
