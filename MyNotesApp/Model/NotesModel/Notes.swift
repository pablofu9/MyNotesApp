//
//  Notes.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 17/10/24.
//

import Foundation
import SwiftData

enum DateComparison {
    case now
    case today
    case yesterday
    case formatted(String)
}


@Model
final class Notes: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var subtitle: String
    var text: String
    var date: Date
    
    init(id: UUID, title: String, subtitle: String, text: String, date: Date) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.text = text
        self.date = date
    }
    
    var stringDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    var dateDescription: DateComparison {
          let now = Date()
          let calendar = Calendar.current
          
          // Comparar las fechas
          if calendar.isDateInToday(date) {
              // Si está en el mismo día
              let components = calendar.dateComponents([.hour], from: date, to: now)
              if let hourDifference = components.hour, hourDifference < 1 {
                  return .now
              } else {
                  return .today
              }
          } else if calendar.isDateInYesterday(date) {
              return .yesterday
          } else {
              // Para cualquier otra fecha
              return .formatted(stringDate)
          }
      }
    
    var dateDescriptionShort: String {
        switch dateDescription {
        case .now:
            return "Right now"
        case .today:
            return "Today"
        case .yesterday:
            return "Yesterday"
        case .formatted(let date):
            return date
        }
    }
}
