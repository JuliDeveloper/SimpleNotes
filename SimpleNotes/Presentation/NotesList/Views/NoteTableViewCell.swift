import UIKit

final class NoteTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.config(
            fontText: .systemFont(ofSize: 17),
            color: .black
        )
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.config(
            fontText: .systemFont(ofSize: 12),
            color: .gray
        )
        return label
    }()
    
    //MARK: - Helpers
    func configUI(for cell: UITableViewCell, from notes: [Note], with indexPath: IndexPath) {
        backgroundColor = .white
        selectionStyle = .none
        
        let note = notes[indexPath.row]
        titleLabel.text = note.title
        subtitleLabel.text = note.body
        if note.isFavorite == true {
            backgroundColor = .lightMainColor.withAlphaComponent(0.5)
        }
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            stack.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 8
            ),
            stack.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            stack.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            )
        ])
    }
}
