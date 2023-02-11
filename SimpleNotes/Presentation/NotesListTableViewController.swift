import UIKit

private let cellIdentifier = "noteCell"

class NotesListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configNavigationBar()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        return cell
    }
}

extension NotesListTableViewController {
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
