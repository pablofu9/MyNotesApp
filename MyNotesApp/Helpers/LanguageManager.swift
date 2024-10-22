//
//  LanguageManager.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 22/10/24.
//

import Foundation

@MainActor
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    @Published var selectedLanguage = "en"
    
    
    func setLanguage(_ languageCode: String) {
        if Bundle.main.localizations.contains(languageCode) {
            UserDefaults.standard.set([languageCode], forKey: "MyLanguages")
            selectedLanguage = languageCode
        }
    }
    
    var supportedLanguages: [String] {
        return ["en", "es"]
    }
    
    func languageDisplayName(for languageCode: String) -> String {
        switch languageCode {
        case "en":
            return "English"
        case "es":
            return "Spanish"
        default:
            return ""
        }
    }
}
