//
//  MainView.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 17/10/24.
//

import SwiftUI
import SwiftData
import Foundation

enum SortOption {
    case dateAsc
    case dateDesc
    case alphabetic
}

struct MainView: View {

    // MARK: - PROPERTIES
    
    @Environment(\.modelContext) private var context
    @State var searchText: String = ""
    @State private var isScrollingDown: Bool = false
    @State private var showSearch: Bool = false
    @Namespace var animation
    @FocusState var isFocused: Bool
    @Query(animation: .spring) private var notes: [Notes]
    @State private var goNewNote: Bool = false
    @State private var addButtonID = UUID()
    @State private var showMenu: Bool = false
    @State private var sortOption: SortOption = .dateDesc
    @State private var showSettings: Bool = false
    @EnvironmentObject var languageManager: LanguageManager
    @AppStorage("MyLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    // MARK: - BODY
    
    var body: some View {
        AnimatedSideBar(
            rotatesWhenExpand: true,
            disablesInteraction: true,
            sideMenuWidth: 200,
            cornerRadius: 25,
            showMenu: $showMenu
        )
        { safeArea in
            navigationContent
        } menuView: { safeArea in
            menuView(
                safeArea
            )
        } background: {
            Rectangle()
                .fill(
                    Color.darkGrayColor
                )
        }
        .sheet(isPresented: $showSettings, content: {
            SettingsView()
        })
        
    }
}

// MARK: - SUBVIEWS

extension MainView {
    
    @ViewBuilder
    private func notesListView() -> some View {
        let filteredNotes = notes.filter { note in
            searchText.isEmpty ||
            note.title.localizedCaseInsensitiveContains(searchText) ||
            note.text.localizedCaseInsensitiveContains(searchText) ||
            note.dateDescriptionShort.localizedCaseInsensitiveContains(searchText)
        }
        
        let sortedNotes: [Notes] = {
            switch sortOption {
            case .dateAsc:
                return filteredNotes.sorted { $0.date < $1.date }
            case .dateDesc:
                return filteredNotes.sorted { $0.date > $1.date }
            case .alphabetic:
                return filteredNotes.sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
            }
        }()
      
        VStack(alignment: .leading, spacing: 1) {
            ForEach(sortedNotes) { note in
                NavigationLink(value: note) {
                    NoteRowView(note: note)
                    .matchedTransitionSource(id: note.id, in: animation)
                }
                .contextMenu {
                    Button {
                        shareNote(note: note)
                    } label: {
                        Label("SHARE".localised(using: currentLanguage), systemImage: "square.and.arrow.up")
                    }

                    Divider()
                    Button(role: .destructive) {
                        context.delete(note)
                    }
                    label: {
                        Label("DELETE".localised(using: currentLanguage), systemImage: "trash")
                    }
                }
                
            }
            
        }
        .overlay {
            if showSearch && searchText.isEmpty {
                Rectangle()
                    .blur(radius: 10)
                    .foregroundStyle(Color.primaryColor.opacity(0.25))
            }
        }
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            VStack {
                HStack(alignment: .bottom,spacing: 15) {
                    if !showSearch {
                        HStack {
                            showMenuButton
                        }
                    }
                    Spacer()
                    if showSearch {
                        searchField
                        cancelButton
                    } else {
                        filterIcon
                        searchButton
                    }
                }
            }
            .padding(.top, UIView.safeAreaTop)
            .padding(.bottom, 20)
            .padding(.trailing, showSearch ? 20 : 0)
            .padding(.horizontal, !showSearch ? 20 : 0)
            .background {
                Rectangle()
                    .foregroundStyle(Color.customWhiteColor)
                    .shadow(color: Color.primaryColor.opacity(0.2), radius: 4, x: 0, y: 3)
            }
            .offset(y: -minY)
        }
        .frame(height: Constants.kHeaderHeight)
    }
    
    @ViewBuilder
    private var searchField: some View {
        TextField("SEARCH".localised(using: currentLanguage), text: $searchText)
            .frame(height: 21)
            .padding(.vertical, 5)
            .padding(.leading, 10)
            .tint(.red)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.secondaryColor.opacity(0.20))
                    .shadow(color: Color.darkGrayColor.opacity(0.1), radius: 2)
            }
            .focused($isFocused)
            .matchedGeometryEffect(id: "search", in: animation)
    }
    
    @ViewBuilder
    private var searchButton: some View {
        Button {
            withAnimation(.smooth(duration: 0.25)) {
                showSearch.toggle()
                isFocused = true
            }
        } label: {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.darkGrayColor)
        }
        .matchedGeometryEffect(id: "search", in: animation)
    }
    
    @ViewBuilder
    private var filterIcon: some View {
        Menu {
            Text("ORDER_BY".localised(using: currentLanguage))
            Divider()
            Button {
                sortOption = .alphabetic
            } label: {
                Label("ORDER_APLHABETIC".localised(using: currentLanguage), systemImage: "textformat.alt")
            }
            
            Button {
                sortOption = .dateAsc
            } label: {
                Label("ORDER_DATE_ASC".localised(using: currentLanguage), systemImage: "arrow.up")
            }
            
            Button {
                sortOption = .dateDesc
            } label: {
                Label("ORDER_DATE_DESC".localised(using: currentLanguage), systemImage: "arrow.down")
            }
        } label: {
            Image(systemName: "line.horizontal.3.decrease.circle")
                .foregroundStyle(Color.darkGrayColor)
        }
    }
    
    @ViewBuilder
    private var cancelButton: some View {
        Button {
            withAnimation(.smooth(duration: 0.25)) {
                searchText = ""
                showSearch.toggle()
            }
        } label: {
            Text("CANCEL".localised(using: currentLanguage))
                .font(.custom(FontNames.kProximaNovaRegular, size: 13))
                .foregroundStyle(Color.secondaryColor)
        }
    }
    
    @ViewBuilder
    private var addButton: some View {
        NavigationLink {
            NoteDetailView(note: nil)
                .navigationTransition(.zoom(sourceID: addButtonID, in: animation))
        } label : {
            Text("+")
                .font(.custom(FontNames.kProximaNovaRegular, size: 45))
                .frame(width: 60, height: 60)
                .foregroundStyle(Color.customWhiteColor)
                .background {
                    Circle()
                        .foregroundStyle(Color.customAccentColor)
                        .shadow(color: Color.primaryColor.opacity(0.4), radius: 4, x: 2, y: 3)

                }
        }
        .padding(.bottom, UIView.safeAreaBottom + 40)
        .padding(.horizontal, 35)
        .matchedTransitionSource(id: addButtonID, in: animation)
    }
    
    @ViewBuilder
    private var content: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    notesListView()
                        .padding(.top, UIView.safeAreaTop + Constants.kHeaderHeight)
                }
                .overlay(alignment: .top) {
                    headerView()
                }
            }
            .scrollDisabled(showSearch)
            .safeAreaInset(edge: .bottom, content: {
                EmptyView()
                    .frame(height: 120)
            })
            .onScrollPhaseChange { oldPhase, newPhase in
                isScrollingDown = newPhase.isScrolling
            }
            .coordinateSpace(name: "SCROLL")
            .onTapGesture {
                withAnimation(.smooth(duration: 0.25)) {
                    if showSearch {
                        showSearch.toggle()
                        searchText = ""
                    }
                    isFocused = false
                }
            }
            addButton
        }
        .background(Color.backgroundColor)
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var navigationContent: some View {
        NavigationStack {
            content
                .navigationDestination(for: Notes.self) { note in
                    NoteDetailView(note: note)
                        .navigationTransition(.zoom(sourceID: note.id, in: animation))
                }
        }
       
    }
    
    @ViewBuilder
    private func menuView(_ safeArea: UIEdgeInsets) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("MENU".localised(using: currentLanguage))
                .font(.custom(FontNames.kProximaNovaBold, size: 22))
                .foregroundStyle(Color.customWhiteColor)
                .padding(.bottom, 30)
            menuItem(text: "SETTINGS".localised(using: currentLanguage), image: "gear", onTap: {
                withAnimation(.smooth) {
                    showMenu = false
                    showSettings.toggle()
                }
            })
            menuItem(text: "ABOUT_US".localised(using: currentLanguage), image: "info.circle", onTap: {
                
            })
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    private var showMenuButton: some View {
        Button {
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                showMenu = true
            }
        } label: {
            Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                .foregroundStyle(Color.darkGrayColor)
                .contentTransition(.symbolEffect)
        }
    }
    
    @ViewBuilder
    private func menuItem(text: String, image: String, onTap: @escaping () -> ()) -> some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: image)
                    .foregroundStyle(Color.customWhiteColor)
                Text(text)
                    .font(.custom(FontNames.kProximaNovaBold, size: 15))
                    .foregroundStyle(Color.customWhiteColor)
            }
        }
    }
}

extension MainView {
    
    private func shareNote(note: Notes) {
        let noteContent = """
        Title: \(note.title)
        Content: \(note.text)
        """

        let activityViewController = UIActivityViewController(activityItems: [noteContent], applicationActivities: nil)

        // Obtener la escena actual y presentar el ActivityViewController
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topController = scene.windows.first?.rootViewController {
            topController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

#Preview(traits: .sampleData) {
    MainView()
}
