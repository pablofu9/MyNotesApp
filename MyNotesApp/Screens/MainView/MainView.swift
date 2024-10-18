//
//  MainView.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 17/10/24.
//

import SwiftUI
import SwiftData


struct MainView: View {

    // MARK: - PROPERTIES
    
    @Environment(\.modelContext) private var context
    @State var searchText: String = ""
    @State private var isScrollingDown: Bool = false
    @State private var showSearch: Bool = false
    @Namespace var animation
    @FocusState var isFocused: Bool
    @Query(animation: .smooth) private var notes: [Notes]
    @State private var goNewNote: Bool = false
    @State private var addButtonID = UUID()
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            content
                .navigationDestination(for: Notes.self) { note in
                    NoteDetailView(note: note)
                        .navigationTransition(.zoom(sourceID: note.id, in: animation))
                }
        }
   
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
        }.sorted(by: { $0.date < $1.date })
      
        VStack(alignment: .leading, spacing: 20) {
            ForEach(filteredNotes) { note in
                NavigationLink(value: note) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(note.title)
                            .foregroundStyle(Color.darkGrayColor)
                            .font(.custom(FontNames.kProximaNovaBold, size: 18))
                        Text(note.dateDescriptionShort)
                            .foregroundStyle(Color.darkGrayColor.opacity(0.5))
                            .font(.custom(FontNames.kProximaNovaRegular, size: 15))
                        Text(note.text)
                            .foregroundStyle(Color.darkGrayColor)
                            .font(.custom(FontNames.kProximaNovaRegular, size: 16))
                            .lineLimit(2)
                        Spacer()
                        Divider()
                            .padding(.top, 10)
                    }
                  
                    .matchedTransitionSource(id: note.id, in: animation)
                }
                .contextMenu {
                    Button {
                        shareNote(note: note)
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }

                    Divider()
                    Button(role: .destructive) {
                        context.delete(note)
                    }
                    label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                
            }
            
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            if showSearch && searchText.isEmpty {
                Rectangle()
                    .blur(radius: 10)
                    .foregroundStyle(Color.customWhiteColor.opacity(0.5))
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
                        Text("Notes")
                            .font(.custom(FontNames.kProximaNovaExtraBold, size: 22))
                            .foregroundStyle(Color.black)
                            .animation(.easeInOut(duration: 0.5), value: !showSearch)
                    }
                    Spacer()
                    if showSearch {
                        searchField
                        cancelButton
                    } else {
                        searchButton
                    }
                   
                }
            }
            .padding(.top, UIView.safeAreaTop)
            .padding(.bottom, 20)
            .padding(.horizontal, 15)
            .background {
                Rectangle()
                    .stroke(Color.lightGrayColor,lineWidth: isScrollingDown ? 0 : 1)
                    .background(Color.customWhiteColor)
                    .shadow(radius: isScrollingDown  ? 5 : 0)
                
            }
            .offset(y: -minY)
        }
        .frame(height:60)
       
    }
    
    @ViewBuilder
    private var searchField: some View {
        TextField("Search", text: $searchText)
            .padding(.vertical, 5)
            .padding(.leading, 10)
            .tint(.red)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.thickMaterial)
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
                .foregroundStyle(Color.black)
        }
        .matchedGeometryEffect(id: "search", in: animation)
    }
    
    @ViewBuilder
    private var cancelButton: some View {
        Button {
            withAnimation(.smooth(duration: 0.25)) {
                searchText = ""
                showSearch.toggle()
            }
        } label: {
            Text("Cancel")
                .font(.custom(FontNames.kProximaNovaLight, size: 18))
                .foregroundStyle(Color.darkGrayColor.opacity(0.5))
        }
    }
    
    @ViewBuilder
    private var addButton: some View {
        NavigationLink {
            NoteDetailView(note: nil)
                .navigationTransition(.zoom(sourceID: addButtonID, in: animation))
        } label : {
            Image(systemName: "document.badge.plus")
                .resizable()
                .frame(width: 30, height: 30)
                .padding(20)
                .foregroundStyle(Color.customWhiteColor)
                .background(Color.softGreenColor)
                .clipShape(Circle())
                .shadow(color: Color.darkGrayColor.opacity(0.4), radius: 5)
        }
        .padding(30)
        .matchedTransitionSource(id: addButtonID, in: animation)

        
    }
    
    @ViewBuilder
    private var content: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if notes.isEmpty {
                        ContentUnavailableView("Notes are empty.", systemImage: "list.clipboard")
                            .padding(.top, 120)
                    } else {
                        notesListView()
                            .padding(.top, 120)
                    }
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
                    }
                    isFocused = false
                }
            }
            addButton
        }
        .ignoresSafeArea()
    }
}

extension MainView {
    
    private func shareNote(note: Notes) {
        let noteContent = """
        Title: \(note.title)
        Subtitle: \(note.subtitle)
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
