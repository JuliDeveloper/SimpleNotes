import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, _ completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(
            title: title, message: message, preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "Да", style: .destructive, handler: completion
        )
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
