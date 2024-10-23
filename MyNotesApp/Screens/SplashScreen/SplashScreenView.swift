//
//  SplashScreenView.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 17/10/24.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var toggle: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text("FNotes")
                .font(.custom(FontNames.kProximaNovaBold, size: 16))
                .foregroundStyle(Color.primaryColor)
                .tracking(2)
            VStack(spacing: 120) {
                Text("Organize your life")
                    .font(.custom(FontNames.kProximaNovaRegular, size: 20))
                    .foregroundStyle(Color.primaryColor.opacity(0.9))
                    .tracking(7)
                Image(.splashIcon)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .rotationEffect(.degrees(toggle ? 360 : 0)) // Rotación de 180 grados
                    .scaleEffect(toggle ? 3 : 1) // Escala de 1 a 1.5
                    .animation(.easeInOut(duration: 1.5), value: toggle)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, UIScreen.main.bounds.size.height / 5)
           
            
        }
        .padding(.horizontal, 20)
        .padding(.top, UIView.safeAreaTop - 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .ignoresSafeArea()
        .background(Color.backgroundColor)
        .onAppear {
            // Iniciar la animación cuando la vista aparece
            withAnimation {
                toggle = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
