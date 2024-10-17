//
//  Item.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 17/10/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
