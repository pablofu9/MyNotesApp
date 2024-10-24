//
//  MyNotesAppApp.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 17/10/24.
//

import SwiftUI
import SwiftData

@main
struct MyNotesAppApp: App {
    
    @StateObject var languageManager = LanguageManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Notes.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppSwitcher()
                .environmentObject(languageManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
