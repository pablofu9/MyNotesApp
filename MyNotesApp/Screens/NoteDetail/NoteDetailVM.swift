//
//  NoteDetailVM.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 18/10/24.
//

import Foundation
@preconcurrency import EventKit
import EventKitUI


@MainActor
class NoteDetailVM: ObservableObject {
    
    @Published var events: [EKEvent]
    let dataStore: CalendarDataStore
    
    init(store: CalendarDataStore = CalendarDataStore()) {
        self.dataStore = store
        self.events = []
    }
    
    func setUpEventStore(date: Date) async throws {
        let response = try await dataStore.verifyAuthorizationStatus()
        
        if response {
            async let lastestEvents = dataStore.fetchEvents(date: date)
            self.events = await lastestEvents
        }
    }
}
