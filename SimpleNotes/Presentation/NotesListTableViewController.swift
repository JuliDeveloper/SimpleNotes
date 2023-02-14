import UIKit

private let cellIdentifier = "noteCell"

protocol ReloadDataTableViewControllerDelegate {
    func reloadData()
}

class NotesListTableViewController: UITableViewController {
    
    private var notes: [Note] = []
    private var storage = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configNavigationBar()
        fetchNotes()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let note = notes[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = note.title
            content.secondaryText = note.body
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = note.title
        }
        
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
            storage.delete(note: note)
        }
    }
}

extension NotesListTableViewController {
    private func fetchNotes() {
        storage.fetchNotes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notesList):
                self.notes = notesList
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )
    }
    
    private func configNavigationBar() {
        title = "Ваши заметки"
        
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
