import UIKit

private let cellIdentifier = "noteCell"

//MARK: - Protocols
protocol NotesListTableViewControllerProtocol: AnyObject {
    var presenter: NotesListTableViewPresenterProtocol? { get set }
}

protocol ReloadDataTableViewControllerDelegate {
    func reloadData()
}

final class NotesListTableViewController: UITableViewController, NotesListTableViewControllerProtocol {
    
    //MARK: - Properties
    private var exampleNotes: [ExampleNote] = []
    private var notes: [Note] = []
    var presenter: NotesListTableViewPresenterProtocol?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NotesListTableViewPresenter(view: self)
        
        setupTableView()
        configNavigationBar()
        fetchNotes()
    }
}

//MARK: - UITableViewDataSource and UITableViewDelegate
extension NotesListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notes.isEmpty {
            return exampleNotes.count
        } else {
            return notes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath
        )
        
        guard let noteCell = cell as? NoteTableViewCell else {
            return UITableViewCell()
        }
                
        noteCell.configUI(for: noteCell, from: notes, with: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newNoteVC = NewNoteViewController()
        
        if notes.isEmpty {
            let exampleNote = exampleNotes[indexPath.row]
            newNoteVC.exampleNote = exampleNote
        } else {
            let note = notes[indexPath.row]
            newNoteVC.note = note
        }
        
        newNoteVC.modalPresentationStyle = .fullScreen
        newNoteVC.delegate = self
        present(newNoteVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = createSwipeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: actions)
    }
}

//MARK: - Helpers
extension NotesListTableViewController {
    private func fetchNotes() {
        presenter?.fetchData { [weak self] notesList in
            guard let self = self else { return }
            self.notes = notesList
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            NoteTableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )
        
        exampleNotes = presenter?.getExampleNotes() ?? [ExampleNote(
            title: "",
            body: "",
            isFavorite: false
        )]
    }
    
    private func configNavigationBar() {
        title = "Ваши заметки"
        navigationController?.navigationBar.barTintColor = .lightMainColor
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewNote)
        )
        navigationController?.navigationBar.tintColor = .mainColor
    }
    
    private func createSwipeAction(at indexPath: IndexPath) -> [UIContextualAction] {
        let actionDelete = UIContextualAction(
            style: .normal,
            title: "Delete"
        ) { [weak self]  (_, _, _) in
            guard let self = self else { return }
            self.showAlert(
                title: "Предупреждение",
                message: "Вы точно хотите удалить заметку?"
            ) { _ in
                if !self.notes.isEmpty {
                    let note = self.notes[indexPath.row]
                    self.presenter?.delete(note: note)
                    if self.notes.count == 1 {
                        self.notes.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    } else {
                        self.notes.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .none)
                    }
                } else {
                    self.exampleNotes.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .none)
                }
            }
        }
        actionDelete.backgroundColor = .red
        actionDelete.image = UIImage(systemName: "trash.fill")
        
        let actionFavorite = UIContextualAction(
            style: .normal,
            title: "Favorite"
        ) { [weak self] (_, _, completion) in
            guard let self = self else { return }
            if !self.notes.isEmpty {
                let note = self.notes[indexPath.row]
                note.isFavorite = !note.isFavorite
                self.presenter?.updateFavoriteState(
                    note: note,
                    newState: note.isFavorite
                )
                self.notes[indexPath.row] = note
            } else {
                var exampleNote = self.exampleNotes[indexPath.row]
                exampleNote.isFavorite = !exampleNote.isFavorite
                self.exampleNotes[indexPath.row] = exampleNote
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        if !notes.isEmpty {
            let note = self.notes[indexPath.row]
            actionFavorite.backgroundColor = note.isFavorite ?
                .mainColor :
                .systemGray
            actionFavorite.image = note.isFavorite ?
                UIImage(systemName: "heart.fill") :
                UIImage(systemName: "heart")
        } else {
            let exampleNote = exampleNotes[indexPath.row]
            actionFavorite.backgroundColor = exampleNote.isFavorite ?
                .mainColor :
                .systemGray
            actionFavorite.image = exampleNote.isFavorite ?
                UIImage(systemName: "heart.fill") :
                UIImage(systemName: "heart")
        }

        let actions: [UIContextualAction] = [actionDelete, actionFavorite]
        return actions
    }
    
    @objc func addNewNote() {
        let newNoteVC = NewNoteViewController()
        newNoteVC.delegate = self
        newNoteVC.modalPresentationStyle = .fullScreen
        present(newNoteVC, animated: true)
    }
}

//MARK: - ReloadDataTableViewControllerDelegate
extension NotesListTableViewController: ReloadDataTableViewControllerDelegate {
    func reloadData() {
        fetchNotes()
        tableView.reloadData()
    }
}
