import Foundation

struct ExampleNote {
    let title: String
    let body: String
    var isFavorite: Bool
    
    static func getExampleNotes() -> [ExampleNote] {
        var exampleNotesList: [ExampleNote] = []
        
        exampleNotesList.append(ExampleNote(
            title: "Пример заметки",
            body: "Описание примера заметки",
            isFavorite: false
        ))
        
        return exampleNotesList
    }
}
