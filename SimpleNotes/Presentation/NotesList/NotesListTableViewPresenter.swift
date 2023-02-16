import Foundation

protocol NotesListTableViewPresenterProtocol {
    var view: NotesListTableViewControllerProtocol? { get set }
    func fetchData(_ completion: ([Note]) -> Void)
    func addExampleNote(exampleTitle: String, exampleBody: String)
    func delete(note: Note)
    func updateFavoriteState(note: Note, newState: Bool)
}

final class NotesListTableViewPresenter: NotesListTableViewPresenterProtocol {
    
    //MARK: - Properties
    private var storage: StorageManager?
    weak var view: NotesListTableViewControllerProtocol?
    
    //MARK: - Lifecycle
    init(view: NotesListTableViewControllerProtocol?, storage: StorageManager = .shared) {
        self.view = view
        self.storage = storage
    }
    
    //MARK: - Helpers
    func fetchData(_ completion: ([Note]) -> Void) {
        storage?.fetchNotes { result in
            switch result {
            case .success(let notesList):
                completion(notesList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addExampleNote(exampleTitle: String, exampleBody: String) {
        storage?.save(noteTitle: exampleTitle, noteBody: exampleBody)
    }
    
    func delete(note: Note) {
        storage?.delete(note: note)
    }
    
    func updateFavoriteState(note: Note, newState: Bool) {
        storage?.edit(note: note, newIsFavoriteState: newState)
    }
}
