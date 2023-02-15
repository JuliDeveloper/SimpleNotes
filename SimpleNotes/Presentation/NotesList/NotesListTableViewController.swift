import UIKit

private let cellIdentifier = "noteCell"

protocol NotesListTableViewControllerProtocol: AnyObject {
    var presenter: NotesListTableViewPresenterProtocol? { get set }
}

protocol ReloadDataTableViewControllerDelegate {
    func reloadData()
}

class NotesListTableViewController: UITableViewController, NotesListTableViewControllerProtocol {
    
    private var notes: [Note] = []
    var presenter: NotesListTableViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NotesListTableViewPresenter(view: self)
        
        setupTableView()
        configNavigationBar()
        fetchNotes()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let noteCell = cell as? NoteTableViewCell else { return UITableViewCell() }
                
        noteCell.configUI(for: noteCell, from: notes, with: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        let newNoteVC = NewNoteViewController()
        newNoteVC.note = note
        
        newNoteVC.modalPresentationStyle = .fullScreen
        newNoteVC.delegate = self
        present(newNoteVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            presenter?.delete(note: note)
        }
    }
}

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
    }
    
    private func configNavigationBar() {
        title = "Ваши заметки"
        navigationController?.navigationBar.barTintColor = .lightMainColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        navigationController?.navigationBar.tintColor = .mainColor
    }
    
    @objc func addNewNote() {
        let newNoteVC = NewNoteViewController()
        newNoteVC.delegate = self
        newNoteVC.modalPresentationStyle = .fullScreen
        present(newNoteVC, animated: true)
    }
}

extension NotesListTableViewController: ReloadDataTableViewControllerDelegate {
    func reloadData() {
        fetchNotes()
        tableView.reloadData()
    }
}
