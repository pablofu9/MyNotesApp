//
//  MainView.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 17/10/24.
//

import SwiftUI
import SwiftData


struct MainView: View {
    
    @Query private var notes: [Notes]
    var safeArea: EdgeInsets
    var size: CGSize
    @State var searchText: String = ""
    @State private var isScrollingDown: Bool = false
    @State private var showSearch: Bool = false
    @Namespace var animation
    @FocusState var isFocused: Bool
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                notesListView()
            }
            .overlay {
                if showSearch {
                    Color.red.opacity(0.6)
                }
            }
            .overlay(alignment: .top) {
                headerView()
            }
        }

    
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
                showSearch.toggle()
                isFocused = false
            }
        }
    }
}

extension MainView {
    

    @ViewBuilder
    private func notesListView() -> some View {
        VStack(alignment: .leading,spacing: 20) {
            ForEach(notes) { note in
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
                    Divider()
                        .padding(.top, 10)
                }
            }
        }
      
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
            .padding(.top, safeArea.top + 60)
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
                showSearch.toggle()
            }
        } label: {
            Text("Cancel")
                .font(.custom(FontNames.kProximaNovaLight, size: 18))
                .foregroundStyle(Color.darkGrayColor.opacity(0.5))
        }
    }
}

#Preview(traits: .sampleData) {
    HomeView()
}
