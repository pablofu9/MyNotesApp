//
//  HomeView.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 17/10/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            MainView(safeArea: safeArea, size: size)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
