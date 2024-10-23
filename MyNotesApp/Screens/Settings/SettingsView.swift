//
//  SettingsView.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 22/10/24.
//

import SwiftUI




struct SettingsView: View {
    

    @State private var refresh = false
    @EnvironmentObject var languageManager: LanguageManager
    @AppStorage("MyLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    @State private var selectedLanguageIndex = 0
    
    var body: some View {
        content
    }
}

extension SettingsView {
    
    @ViewBuilder
    private func settingsRowLanguage(text: String, image: String) -> some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 20) {
                    Text(text)
                        .font(.custom(FontNames.kProximaNovaRegular, size: 20))
                        .foregroundStyle(Color.customWhiteColor)
                    Image(systemName: image)
                        .foregroundStyle(Color.customWhiteColor)
                }
                HStack(spacing: 20) {
                    langugeList(proxy: proxy)
                   
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.black.opacity(0.4))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func langugeList(proxy: GeometryProxy) -> some View {
        if languageManager.supportedLanguages.count > 0 {
            ForEach(0..<languageManager.supportedLanguages.count, id: \.self) { index in
                Button {
                    let languageCode = languageManager.supportedLanguages[index]
                    languageManager.setLanguage(languageCode)
                    currentLanguage = languageCode
                    selectedLanguageIndex = index
                } label: {
                    Text(languageManager.languageDisplayName(for: languageManager.supportedLanguages[index]))
                        .frame(width: proxy.size.width / 2.5)
                        .padding(.vertical, 7)
                        .foregroundStyle(selectedLanguageIndex == index ? Color.darkGrayColor : Color.customWhiteColor)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedLanguageIndex == index ? Color.white : Color.clear, lineWidth: 2)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedLanguageIndex == index ? Color.white : Color.clear)
                                )
                        }
                }
                .onAppear {
                    if let index = languageManager.supportedLanguages.firstIndex(of: currentLanguage) {
                        selectedLanguageIndex = index
                    } else {
                        let defaultLanguage = "en"
                        if let defaultIndex = languageManager.supportedLanguages.firstIndex(of: defaultLanguage) {
                            selectedLanguageIndex = defaultIndex
                            currentLanguage = defaultLanguage
                            languageManager.setLanguage(defaultLanguage)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func darkLightMode(proxy: GeometryProxy) -> some View {
        
    }
    
    @ViewBuilder
    private var content: some View {
        ZStack {
            LazyVStack(alignment: .leading, spacing: 20) {
                Text("SETTINGS".localised(using: currentLanguage))
                    .font(.custom(FontNames.kProximaNovaExtraBold, size: 34))
                    .foregroundStyle(Color.customWhiteColor)
                Divider()
                    .frame(height: 2)
                    .background(Color.customWhiteColor.opacity(0.2))
                
                settingsRowLanguage(text: "LANGUAGE".localised(using: currentLanguage), image: "globe")
                .padding(.top, 30)
             
            }
            .padding(.horizontal, 25)
            .padding(.top, UIView.safeAreaTop)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .ignoresSafeArea()
        .background(Color.darkGrayColor)
    }
    
}

#Preview {
    SettingsView()
        .environmentObject(LanguageManager.init())
}
