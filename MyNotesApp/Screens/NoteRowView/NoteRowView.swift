//
//  NoteRowView.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 22/10/24.
//

import SwiftUI

struct NoteRowView: View {
    
    // MARK: - PROPERTIES
    
    let note: Notes
    
    // MARK: - BODY
    
    var body: some View {
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
    }
}

#Preview(traits: .sampleData) {
    NoteRowView(note: SampleNotes.SampleNotes.exampleNote)
}
