//
//  UIApplication.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 18/10/24.
//

import UIKit

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow })
    }
}
