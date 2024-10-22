//
//  Localizable.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 22/10/24.
//

import Foundation

protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

