import UIKit

public final class DebugMenuSDK {
    public static let shared = DebugMenuSDK()
    private init() {}

    // Окно с меню (поверх всего)
    private var overlayWindow: UIWindow?

    // Прозрачное окно-детектор жестов/шейка
    private var detectorWindow: DetectorWindow?

    // MARK: - Public API

    /// Включить глобальные триггеры: shake + трехпальцевый свайп (в любом направлении).
    public func enableGlobalTriggers() {
        onMain {
            UIApplication.shared.applicationSupportsShakeToEdit = true

            guard self.detectorWindow == nil,
                  let scene = Self.activeWindowScene() else { return }

            let win = DetectorWindow(windowScene: scene)
            win.windowLevel = .statusBar + 1
            win.backgroundColor = .clear
            win.isHidden = false
            win.isUserInteractionEnabled = true

            // Три пальца, любой свайп
            for dir in [UISwipeGestureRecognizer.Direction.up, .down, .left, .right] {
                let g = UISwipeGestureRecognizer(target: self, action: #selector(Self.handleThreeFingerSwipe(_:)))
                g.numberOfTouchesRequired = 3
                g.direction = dir
                g.cancelsTouchesInView = false
                win.addGestureRecognizer(g)
            }

            win.makeKey()
            _ = win.becomeFirstResponder()

            self.detectorWindow = win
        }
    }

    /// Отключить триггеры и убрать служебное окно
    public func disableGlobalTriggers() {
        onMain {
            self.detectorWindow?.isHidden = true
            self.detectorWindow = nil
        }
    }

    /// Показать меню поверх всего UI
    public func show() {
        onMain {
            guard self.overlayWindow == nil,
                  let scene = Self.activeWindowScene() else { return }

            let window = UIWindow(windowScene: scene)
            window.windowLevel = .alert + 1
            window.backgroundColor = .clear
            window.rootViewController = DebugMenuContainerVC()
            window.isHidden = false
            self.overlayWindow = window
        }
    }

    /// Спрятать меню
    public func hide() {
        onMain {
            self.overlayWindow?.isHidden = true
            self.overlayWindow = nil
        }
    }

    /// Переключить состояние меню
    public func toggle() {
        onMain {
            if self.overlayWindow == nil { self.show() } else { self.hide() }
        }
    }

    // MARK: - Internal handlers

    @objc private func handleThreeFingerSwipe(_ recognizer: UISwipeGestureRecognizer) {
        toggle() // безопасно: toggle() сам отправит на main при необходимости
    }

    // MARK: - Helpers

    /// Активная foreground-сцена (всегда зови с main)
    private static func activeWindowScene() -> UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }

    /// Выполнить блок на главном потоке без двойного диспатча
    @inline(__always)
    private func onMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread { block() } else { DispatchQueue.main.async { block() } }
    }
}

// MARK: - Прозрачное окно-детектор
private final class DetectorWindow: UIWindow {
    // Не перехватываем тачи приложения — пропускаем хит-тест
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool { false }

    // Разрешаем получать shake-события
    override var canBecomeFirstResponder: Bool { true }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        DebugMenuSDK.shared.toggle() // сам диспатчит на main в нужный момент
    }
}

// MARK: - UI меню (простая карточка)
final class DebugMenuContainerVC: UIViewController {
    private lazy var dimView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var cardView: UIVisualEffectView = {
        let v = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Debug Menu"
        l.textColor = .white
        l.font = .boldSystemFont(ofSize: 20)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var closeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Close", for: .normal)
        b.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(dimView)
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTapped)))

        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 300),
            cardView.heightAnchor.constraint(equalToConstant: 200),
        ])

        cardView.contentView.addSubview(titleLabel)
        cardView.contentView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            closeButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            closeButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
        ])
    }

    @objc private func closeTapped() {
        DebugMenuSDK.shared.hide()
    }
}
