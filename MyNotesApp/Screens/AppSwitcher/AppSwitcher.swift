//
//  AppSwitcher.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 23/10/24.
//

import SwiftUI

struct AppSwitcher: View {
    
    @State private var showSplash: Bool = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView()
                    .transition(CustomSplashTransition(isRoot: false))
            } else {
                MainView()
                    .transition(CustomSplashTransition(isRoot: false))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .ignoresSafeArea()
        .task {
            guard showSplash else { return }
            try? await Task.sleep(for: .seconds(1.7))
            withAnimation(.smooth(duration: 0.8)) {
                showSplash = false
            }
        }
    }
}



#Preview {
    AppSwitcher()
}
