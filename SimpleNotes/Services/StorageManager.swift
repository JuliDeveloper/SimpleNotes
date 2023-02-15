import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimpleNotes")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Metods
    func fetchNotes(_ completion: (Result<[Note], Error>) -> Void) {
        let request = Note.fetchRequest()
        
        do {
            let notes = try viewContext.fetch(request)
            completion(.success(notes))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func save(noteTitle: String, noteBody: String) {
        let note = Note(context: viewContext)
        note.title = noteTitle
        note.body = noteBody
        saveContext()
    }
    
    func edit(note: Note, newTitle: String, newBody: String) {
        note.title = newTitle
        note.body = newBody
        saveContext()
    }
    
    func delete(note: Note) {
        viewContext.delete(note)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
