import UIKit

final class NewNoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cохранить", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noteTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Заголовок заметки"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.mainColor.cgColor
        textField.layer.cornerRadius = 8
        
        let spacer = UIView()
        spacer.frame = CGRect(x: 0, y: 0, width: 10, height: 31)
        textField.leftView = spacer
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.mainColor.cgColor
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var note: Note?
    var delegate: ReloadDataTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        addSubviews()
        setupConstraints()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
        
        noteTitleTextField.delegate = self
        noteTextView.delegate = self
        
        if note != nil {
            noteTitleTextField.text = note?.title
            noteTextView.text = note?.body
        }
    }
    
    private func addSubviews() {
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        view.addSubview(noteTitleTextField)
        view.addSubview(noteTextView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),
            cancelButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            )
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),
            saveButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            )
        ])
        
        NSLayoutConstraint.activate([
            noteTitleTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            noteTitleTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            noteTitleTextField.topAnchor.constraint(
                equalTo: cancelButton.bottomAnchor,
                constant: 20
            ),
            noteTitleTextField.heightAnchor.constraint(
                equalToConstant: 31
            )
        ])
        
        NSLayoutConstraint.activate([
            noteTextView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            noteTextView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            noteTextView.topAnchor.constraint(
                equalTo: noteTitleTextField.bottomAnchor,
                constant: 20
            ),
            noteTextView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            )
        ])
    }
    
    @objc func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc func didTapSave() {
        if note == nil {
            StorageManager.shared.save(
                noteTitle: noteTitleTextField.text ?? "",
                noteBody: noteTextView.text ?? ""
            )
        } else {
            StorageManager.shared.edit(
                note: note ?? Note(), newTitle: noteTitleTextField.text ?? "",
                newBody: noteTextView.text ?? ""
            )
        }
        
        delegate?.reloadData()
        dismiss(animated: true)
    }
}
