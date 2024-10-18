//
//  CalendarViewController.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 18/10/24.
//

import Foundation



import Foundation
import SwiftUI
import EventKit
import EventKitUI

struct CalendarViewController: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    @Binding var event: EKEvent?
    let eventStore: EKEventStore
    let preselectedDate: Date
    let preselectedTitle: String
    let description: String
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        
        if event == nil {
            let newEvent = EKEvent(eventStore: eventStore)
            newEvent.title = preselectedTitle
            newEvent.startDate = preselectedDate
            newEvent.notes = description
            controller.event = newEvent
        } else {
            controller.event = event
        }
        
        controller.editViewDelegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, @preconcurrency EKEventEditViewDelegate {
        var parent: CalendarViewController
        
        init(_ controller: CalendarViewController) {
            self.parent = controller
        }
        
        @MainActor func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.dismiss()
        }
    }
}


