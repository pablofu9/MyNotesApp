//
//  CalendarDataStore.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 18/10/24.
//

import Foundation
import EventKit
import EventKitUI


actor CalendarDataStore {
    let eventStore: EKEventStore = EKEventStore()
    
    func fetchEvents(date: Date) -> [EKEvent] {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        return eventStore.events(matching: predicate)
    }
    
    func verifyAuthorizationStatus() async throws -> Bool {
        
        let status = EKEventStore.authorizationStatus(for: .event)
        
        if status == .notDetermined {
            let granted = try await requestEventStoreAccess()
            return granted
        }
        
        return status == .fullAccess
    }
    
    private func requestEventStoreAccess() async throws -> Bool {
        if #available(iOS 17.0, *) {
            return try await requestFullAccessToEvents()
        } else {
            return try await requestAccessForOlderVersions()
        }
    }
    
    private func requestFullAccessToEvents() async throws -> Bool {
        // Method only available in iOS 17.0 and later
        try await withCheckedThrowingContinuation { continuation in
            if #available(iOS 17.0, *) {
                eventStore.requestFullAccessToEvents { granted, error in
                    
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: granted)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private func requestAccessForOlderVersions() async throws -> Bool {
        // Use for iOS 16 and earlier
        try await withCheckedThrowingContinuation { continuation in
            eventStore.requestFullAccessToEvents() { granted, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: granted)
                }
            }
        }
    }
}
