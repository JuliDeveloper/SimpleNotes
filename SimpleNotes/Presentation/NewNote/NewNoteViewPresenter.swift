import Foundation

protocol NewNoteViewPresenterProtocol {
    var view: NewNoteViewControllerProtocol? { get set }
    func save(noteTitle: String, noteBody: String)
    func edit(note: Note, newTitle: String, newBody: String)
}

class NewNoteViewPresenter: NewNoteViewPresenterProtocol {
    private var storage: StorageManager?
    weak var view: NewNoteViewControllerProtocol?
    
    init(view: NewNoteViewControllerProtocol?, storage: StorageManager = .shared) {
        self.storage = storage
        self.view = view
    }

    func save(noteTitle: String, noteBody: String) {
        storage?.save(noteTitle: noteTitle, noteBody: noteBody)
    }
    
    func edit(note: Note, newTitle: String, newBody: String) {
        storage?.edit(note: note, newTitle: newTitle, newBody: newBody)
    }
}
