import UIKit

public final class DebugMenuSDK {
    public static let shared = DebugMenuSDK()

    private init() {}

    private var menuVC: UIViewController?

    @MainActor
    public func showMenu(on viewController: UIViewController) {
        let vc = DebugMenuViewController()
        vc.modalPresentationStyle = .overFullScreen
        viewController.present(vc, animated: true)
        menuVC = vc
    }
}

final class DebugMenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        let label = UILabel()
        label.text = "Debug Menu"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
