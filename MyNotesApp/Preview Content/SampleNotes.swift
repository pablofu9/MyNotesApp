//
//  SampleNotes.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 17/10/24.
//

import SwiftUI
import SwiftData

struct SampleNotes: PreviewModifier {
    
    struct SampleNotes {
        @MainActor static let exampleNote = Notes(id: UUID(), title: "Sample Note", text: "This is a sample note for preview purposes.", date: .now)
    }
    
    static func makeSharedContext() async throws -> ModelContainer {
        let schema = Schema([
            Notes.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container =  try ModelContainer(for: schema, configurations: [modelConfiguration])
        
        let note1 = Notes(id: UUID(), title: "Primera nota", text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note2 = Notes(id: UUID(), title: "Segunda nota", text: "", date: .now)
      
        let note3 = Notes(id: UUID(), title: "Segunda nota", text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note4 = Notes(id: UUID(), title: "Segunda nota", text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note5 = Notes(id: UUID(), title: "Segunda nota",text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note6 = Notes(id: UUID(), title: "Segunda nota", text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note7 = Notes(id: UUID(), title: "Segunda nota", text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note8 = Notes(id: UUID(), title: "Segunda nota",  text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note9 = Notes(id: UUID(), title: "Segunda nota",  text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note10 = Notes(id: UUID(), title: "Segunda nota", text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note11 = Notes(id: UUID(), title: "Segunda nota", text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        let note12 = Notes(id: UUID(), title: "Segunda nota", text: "Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo . Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de  va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo.", date: .now)
        container.mainContext.insert(note1)
        container.mainContext.insert(note2)
        container.mainContext.insert(note3)
        container.mainContext.insert(note4)
        container.mainContext.insert(note5)
        container.mainContext.insert(note6)
        container.mainContext.insert(note7)
        container.mainContext.insert(note8)
        container.mainContext.insert(note9)
        container.mainContext.insert(note10)
        container.mainContext.insert(note11)
        container.mainContext.insert(note12)

        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleNotes())
}
