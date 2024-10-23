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
        VStack(alignment: .leading, spacing: 3) {
            Text(note.title)
                .font(.custom(FontNames.kProximaNovaBold, size: 16))
                .foregroundStyle(Color.primaryColor)
            Text(note.dateDescriptionShort)
                .font(.custom(FontNames.kProximaNovaRegular, size: 13))
                .foregroundStyle(Color.secondaryColor)
            Text(note.text)
                .font(.custom(FontNames.kProximaNovaRegular, size: 13))
                .foregroundStyle(Color.primaryColor.opacity(0.85))
        }
        .padding(.leading, 21)
        .padding(.top, 6)
        .padding(.trailing, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100, alignment: .top)
        .background(Color.customWhiteColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.primaryColor.opacity(0.4), radius: 4, x: 0, y: 3)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview(traits: .sampleData) {
    NoteRowView(note: SampleNotes.SampleNotes.exampleNote)
}
