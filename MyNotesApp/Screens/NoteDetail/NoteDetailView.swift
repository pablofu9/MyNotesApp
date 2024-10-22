//
//  NoteDetailView.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 18/10/24.
//

import SwiftUI
import EventKit

struct NoteDetailView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var content: String = ""
    var note: Notes?
    @State private var isScrollingDown: Bool = false
    @Namespace var animation
    @State private var showCalendarViewController = false
    @StateObject private var noteDetailVM = NoteDetailVM()
    @State private var EKevent: EKEvent?
    @State private var store = EKEventStore()
    @State private var buttonbackPressed: Bool = false
    @EnvironmentObject var languageManager: LanguageManager
    @AppStorage("MyLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    // MARK: - INIT
    
    init(note: Notes?) {
        self.note = note
        if let note = note {
            _title = .init(initialValue: note.title)
            _subtitle = .init(initialValue: note.subtitle)
            _content = .init(initialValue: note.text)
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden()
            .sheet(isPresented: $showCalendarViewController) {
                CalendarViewController(event: $EKevent,
                                       eventStore: store,
                                       preselectedDate: .now,
                                       preselectedTitle: title,
                                       description: content)
            }
            .onDisappear {
                if !buttonbackPressed {
                    saveChangesIfNeeded()
                }
            }
    }
}

// MARK: - SUBVIEWS

extension NoteDetailView {
    
    @ViewBuilder
    private func headerView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLLDETAIL")).minY
            VStack {
                HStack(alignment: .bottom, spacing: 15) {
                    arrowBackButton
                    Spacer()
                    if minY < -40, !title.isEmpty {
                        Text(title)
                            .font(.custom(FontNames.kProximaNovaBold, size: 20))
                            .foregroundStyle(Color.darkGrayColor)
                            .frame(height: 20)
                            .matchedGeometryEffect(id: "title", in: animation)
                            .animation(.easeInOut(duration: 0.25), value: minY < -40)
                    } else {
                        Text("")
                            .frame(height: 20)
                    }

                    Spacer()
                    menuButton
                }
                .padding(.top, UIView.safeAreaTop)
                .padding(.bottom, 20)
                .padding(.horizontal, 15)
                .background {
                    Rectangle()
                        .stroke(Color.lightGrayColor, lineWidth: isScrollingDown ? 0 : 1)
                        .background(Color.customWhiteColor)
                        .shadow(radius: isScrollingDown  ? 5 : 0)
                }
                .offset(y: -minY)
            }
        }
        .frame(height: 60)
        .frame(maxHeight: 60)
    }
    
    @ViewBuilder
    private var arrowBackButton: some View {
        Button {
            buttonbackPressed = true
            saveChangesIfNeeded()
            withAnimation(.smooth(duration: 0.75)) {
                dismiss()
            }
        } label: {
            Image(systemName: "arrow.left")
                .foregroundStyle(Color.darkGrayColor)
        }
    }
    
    @ViewBuilder
    private var menuButton: some View {
        Menu {
            shareButton
            addToCalendarButton
            Divider()
            deleteButton
        } label: {
            Image(systemName: "pencil")
                .foregroundStyle(Color.darkGrayColor)

        }
        .menuStyle(.borderlessButton)

    }
    
    @ViewBuilder
    private var formView: some View {
        LazyVStack(spacing: 20) {
            TextEditor(text: $title)
                        .frame(minHeight: 40, maxHeight: 70)
                        .lineLimit(2)
                        .foregroundStyle(Color.darkGrayColor)
                        .font(.custom(FontNames.kProximaNovaExtraBold, size: 26))
                        .tint(Color.warningRedColor)
                        .padding(.horizontal, 4)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .foregroundStyle(Color.darkGrayColor.opacity(0.7))
                                .frame(height: 1)
                                .offset(y: 3)
                        }
                        .overlay(alignment: .bottom) {
                            if title.isEmpty {
                                HStack {
                                    Text("NOTE_DETAIL_TITLE".localised(using: currentLanguage))
                                        .foregroundStyle(Color.darkGrayColor.opacity(0.4))
                                        .font(.custom(FontNames.kProximaNovaLight, size: 26))
                                    Spacer()
                                }
                                .padding(.leading, 8)
                            }
                        }
                        .background(Color.clear)
            TextEditor(text: $subtitle)
                        .frame(minHeight: 40, maxHeight: 70)
                        .lineLimit(2)
                        .foregroundStyle(Color.darkGrayColor)
                        .font(.custom(FontNames.kProximaNovaBlack, size: 18))
                        .tint(Color.warningRedColor)
                        .padding(.horizontal, 4)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .foregroundStyle(Color.darkGrayColor.opacity(0.3))
                                .frame(height: 1)
                                .offset(y: 3)
                        }
                        .overlay(alignment: .center) {
                            if subtitle.isEmpty {
                                HStack {
                                    Text("NOTE_DETAIL_SUBTITLE".localised(using: currentLanguage))
                                        .foregroundStyle(Color.darkGrayColor.opacity(0.4))
                                        .font(.custom(FontNames.kProximaNovaLight, size: 18))
                                    Spacer()
                                }
                                .padding(.leading, 8)
                            }
                        }
                        .background(Color.clear)
            TextEditor(text: $content)
                .frame(minHeight: 40, maxHeight: .infinity)
                        .lineLimit(2)
                        .foregroundStyle(Color.darkGrayColor)
                        .font(.custom(FontNames.kProximaNovaRegular, size: 16))
                        .tint(Color.warningRedColor)
                        .padding(.horizontal, 4)
                     
                        .overlay(alignment: .center) {
                            if content.isEmpty {
                                HStack {
                                    Text("NOTE_DETAIL_START_TYPING".localised(using: currentLanguage))
                                        .foregroundStyle(Color.darkGrayColor.opacity(0.4))
                                        .font(.custom(FontNames.kProximaNovaRegular, size: 16))
                                    Spacer()
                                }
                                .padding(.leading, 8)
                            }
                        }
                        .background(Color.clear)
                
        }
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    private var contentView: some View {
        ZStack {
            ScrollView {
                formView
                .padding(.top, UIView.safeAreaTop + 60)
                .overlay(alignment: .top) {
                    headerView()
                }
            }
            .coordinateSpace(name: "SCROLLDETAIL")
            .onScrollPhaseChange { oldPhase, newPhase in
                isScrollingDown = newPhase.isScrolling
            }
            .safeAreaInset(edge: .bottom, content: {
                EmptyView()
                    .frame(height: UIView.safeAreaBottom)
            })
        }
        .background(Color.customWhiteColor)
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        if let note {
            Button(role: .destructive) {
                withAnimation(.smooth(duration: 0.55)) {
                    context.delete(note)
                    dismiss()
                }
            } label: {
                Label("DELETE".localised(using: currentLanguage), systemImage: "trash")
                    .tint(.warningRedColor)
            }
        }
    }
    
    @ViewBuilder
    private var addToCalendarButton: some View {
        Button {
            Task {
                let granted = try await noteDetailVM.dataStore.verifyAuthorizationStatus()
                if granted {
                    showCalendarViewController = true
                } else {
                    print("Access denied")
                }
            }
            
        } label: {
            Label("NOTE_DETAIL_ADD_CALENDAR".localised(using: currentLanguage), systemImage: "calendar.badge.plus")
        }
    }
    
    @ViewBuilder
    private var shareButton: some View {
        Button {
            withAnimation(.smooth(duration: 0.25)) {
                shareNote()
            }
        } label: {
            Label("NOTE_DETAIL_SHARE_NOTE".localised(using: currentLanguage), systemImage: "square.and.arrow.up")
        }
        
    }
}

// MARK: - PRIVATE FUNCS

extension NoteDetailView {
    
    
    private func shareNote() {
        let noteContent = """
        Title: \(title)
        Subtitle: \(subtitle)
        Content: \(content)
        """

        let activityViewController = UIActivityViewController(activityItems: [noteContent], applicationActivities: nil)

        // Obtener la escena actual y presentar el ActivityViewController
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topController = scene.windows.first?.rootViewController {
            topController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func saveChangesIfNeeded() {
        if let note {
            if note.title != title || note.subtitle != subtitle || note.text != content {
                note.title = title
                note.subtitle = subtitle
                note.text = content
            }
        } else {
            if !title.isEmpty || !subtitle.isEmpty || !content.isEmpty {
                let newNote = Notes(id: UUID(), title: title, subtitle: subtitle, text: content, date: .now)
                context.insert(newNote)
            }
        }
    }
    
}

#Preview (traits: .sampleData){
    NoteDetailView(note: nil)
}
