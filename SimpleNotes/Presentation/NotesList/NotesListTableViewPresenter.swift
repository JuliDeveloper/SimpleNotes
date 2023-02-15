import Foundation

protocol NotesListTableViewPresenterProtocol {
    var view: NotesListTableViewControllerProtocol? { get set }
    func fetchData(_ completion: ([Note]) -> Void)
    func delete(note: Note)
}

class NotesListTableViewPresenter: NotesListTableViewPresenterProtocol {
    
    private var storage: StorageManager?
    weak var view: NotesListTableViewControllerProtocol?
    
    init(view: NotesListTableViewControllerProtocol?, storage: StorageManager = .shared) {
        self.view = view
        self.storage = storage
    }
    
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
    
    func delete(note: Note) {
        storage?.delete(note: note)
    }
}
