import UIKit

protocol NewNoteViewControllerProtocol: AnyObject {
    var presenter: NewNoteViewPresenterProtocol? { get set }
}

final class NewNoteViewController: UIViewController, NewNoteViewControllerProtocol {
    
    //MARK: - Properties
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.config(
            title: "Отмена",
            font: .systemFont(ofSize: 15)
        )
        button.addTarget(
            self,
            action: #selector(didTapCancel),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.config(
            title: "Cохранить",
            font: .boldSystemFont(ofSize: 15)
        )
        button.addTarget(
            self,
            action: #selector(didTapSave),
            for: .touchUpInside
        )
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
        textField.addTarget(
            self,
            action: #selector(changeStateSaveButton),
            for: .editingChanged
        )
        return textField
    }()
    
    private let noteBodyTextView: UITextView = {
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NewNoteViewPresenter(view: self)
        
        setupViewController()
        addSubviews()
        setupConstraints()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification, object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

//MARK: - Helpers
extension NewNoteViewController {
    private func setupViewController() {
        view.backgroundColor = .white
        
        topStackView.addArrangedSubview(cancelButton)
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(saveButton)
        
        noteTitleTextField.delegate = self
        
        saveButton.isEnabled = false
        
        if note != nil {
            titleLabel.text = "Редактирование"
            saveButton.isEnabled = true
            noteTitleTextField.text = note?.title
            noteBodyTextView.text = note?.body
        }
    }
    
    private func addSubviews() {
        view.addSubview(topStackView)
        view.addSubview(noteTitleTextField)
        view.addSubview(noteBodyTextView)
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
            noteBodyTextView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            noteBodyTextView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            noteBodyTextView.topAnchor.constraint(
                equalTo: noteTitleTextField.bottomAnchor,
                constant: 20
            ),
            noteBodyTextView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            )
        ])
    }
    
    private func moveViewWithKeyboard(notification: NSNotification, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
                        
        NSLayoutConstraint.activate([
            noteBodyTextView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: (-keyboardHeight + 20)
            )
        ])
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, keyboardWillShow: true)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
       moveViewWithKeyboard(notification: notification, keyboardWillShow: false)
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
                noteBody: noteBodyTextView.text ?? ""
            )
        } else {
            presenter?.edit(
                note: note ?? Note(),
                newTitle: noteTitleTextField.text ?? "",
                newBody: noteBodyTextView.text ?? ""
            )
        }
        
        delegate?.reloadData()
        dismiss(animated: true)
    }
}

extension NewNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == noteTitleTextField {
            noteBodyTextView.becomeFirstResponder()
        }
        
        return true
    }
}
