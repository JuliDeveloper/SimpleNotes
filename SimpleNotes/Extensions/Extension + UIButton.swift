import UIKit

extension UIButton {
    func config(title: String, font: UIFont) {
        setTitle(title, for: .normal)
        titleLabel?.font = font
        tintColor = .mainColor
    }
}
