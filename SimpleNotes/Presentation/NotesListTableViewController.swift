import UIKit

private let cellIdentifier = "noteCell"

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
        
        cell.textLabel?.text = note.title
        
        return cell
    }
}

extension NotesListTableViewController {
    private func fetchNotes() {
        storage.fetchNotes { result in
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
        newNoteVC.modalPresentationStyle = .fullScreen
        present(newNoteVC, animated: true)
    }
}
