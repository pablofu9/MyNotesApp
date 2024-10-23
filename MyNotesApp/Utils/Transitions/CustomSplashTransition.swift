//
//  CustomSplashTransition.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 23/10/24.
//

import Foundation
import SwiftUI

struct CustomSplashTransition: Transition {
    var isRoot: Bool
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .offset(y: phase.isIdentity ? 0 : isRoot ? screnSize.height : -screnSize.height)
    }
    
    var screnSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        return .zero
    }
}
