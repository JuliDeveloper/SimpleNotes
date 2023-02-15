import UIKit

protocol NewNoteViewControllerProtocol: AnyObject {
    var presenter: NewNoteViewPresenterProtocol? { get set }
}

final class NewNoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, NewNoteViewControllerProtocol {
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cохранить", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая заметка"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var noteTitleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.tintColor = .mainColor
        textField.placeholder = "Заголовок заметки"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.mainColor.cgColor
        textField.layer.cornerRadius = 8
        
        let spacer = UIView()
        spacer.frame = CGRect(x: 0, y: 0, width: 10, height: 31)
        textField.leftView = spacer
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(changeStateSaveButton), for: .editingChanged)
        return textField
    }()
    
    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.tintColor = .mainColor
        textView.font = .systemFont(ofSize: 15)
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.mainColor.cgColor
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var note: Note?
    var delegate: ReloadDataTableViewControllerDelegate?
    var presenter: NewNoteViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NewNoteViewPresenter(view: self)
        
        setupViewController()
        addSubviews()
        setupConstraints()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
        
        topStackView.addArrangedSubview(cancelButton)
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(saveButton)
        
        noteTitleTextField.delegate = self
        noteTextView.delegate = self
        
        saveButton.isEnabled = false
        
        if note != nil {
            titleLabel.text = "Редактирование"
            saveButton.isEnabled = true
            noteTitleTextField.text = note?.title
            noteTextView.text = note?.body
        }
    }
    
    private func addSubviews() {
        view.addSubview(topStackView)
        view.addSubview(noteTitleTextField)
        view.addSubview(noteTextView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            topStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),
            topStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16)
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
                equalTo: topStackView.bottomAnchor,
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
    
    @objc private func changeStateSaveButton() {
        if noteTitleTextField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @objc private func didTapCancel() {
        showAlert(
            title: "Предупреждение",
            message: "Вы точно хотите отменить редактирование?"
        ) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    @objc private func didTapSave() {
        if note == nil {
            presenter?.save(
                noteTitle: noteTitleTextField.text ?? "",
                noteBody: noteTextView.text ?? ""
            )
        } else {
            presenter?.edit(
                note: note ?? Note(),
                newTitle: noteTitleTextField.text ?? "",
                newBody: noteTextView.text ?? ""
            )
        }
        
        delegate?.reloadData()
        dismiss(animated: true)
    }
}
