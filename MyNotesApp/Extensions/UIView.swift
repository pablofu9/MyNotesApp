//
//  UIView.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 18/10/24.
//

import UIKit

// MARK: - SAFE AREA EXTENSION

extension UIView {
    static var safeAreaBottom: CGFloat {
        if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.bottom
            }
        }
        return 0
    }

    static var safeAreaTop: CGFloat {
        if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.top
            }
        }
        return 0
    }
}
