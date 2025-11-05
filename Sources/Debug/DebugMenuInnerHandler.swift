import UIKit
import SwiftUI

// MARK: - Default Handlers
final class DebugMenuInnerHandler: DebugMenuInnerDelegate {
    func showSetEmailAlert(_ viewController: UIViewController, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(
            title: "Set Debug Email",
            message: "Введите email, он сохранится для отладочных сценариев.",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "email@example.com"
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.text = DebugMenuUserDefaultsService.shared.emailForCheck
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let save = UIAlertAction(title: "Save", style: .default) { [weak alert] _ in
            guard let text = alert?.textFields?.first?.text else { return }
            
            DebugMenuUserDefaultsService.shared.emailForCheck = text
            completion(text)
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        viewController.present(alert, animated: true)
    }
    
    
    func didTapCrash() {
        let array = [1]
        _ = array[100]
    }
    
    func didTapOpenGeneratorApp() {
        let view = MainViewGenerator()
        let host = UIHostingController(rootView: view)
        host.modalPresentationStyle = .formSheet
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.keyWindow?.rootViewController {
            root.topMost.present(host, animated: true)
        }
    }
}
