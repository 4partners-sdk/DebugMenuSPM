import UIKit

public final class DebugMenuSDK {
    public static let shared = DebugMenuSDK()
    private init() {}

    // Окно с самим меню (поверх всего)
    private var overlayWindow: UIWindow?

    // Служебное окно-детектор жестов/шейка (прозрачное, не мешает тачам)
    private var detectorWindow: DetectorWindow?

    // MARK: - Public API

    /// Включает глобальные триггеры: Shake + трехпальцевый свайп (в любом направлении).
    @MainActor
    public func enableGlobalTriggers() {
        // (опционально) включает системную обработку шейка; нам не обязательно, но иногда помогает
        UIApplication.shared.applicationSupportsShakeToEdit = true

        guard detectorWindow == nil,
              let scene = Self.activeWindowScene() else { return }

        let win = DetectorWindow(windowScene: scene)
        win.windowLevel = .statusBar + 1
        win.backgroundColor = .clear
        win.isHidden = false
        win.isUserInteractionEnabled = true

        // триггеры — не блокируем пользовательские касания
        for dir in [UISwipeGestureRecognizer.Direction.up,
                    .down, .left, .right] {
            let g = UISwipeGestureRecognizer(target: self, action: #selector(handleThreeFingerSwipe))
            g.numberOfTouchesRequired = 3
            g.direction = dir
            g.cancelsTouchesInView = false
            win.addGestureRecognizer(g)
        }

        // важный момент: делаем окно key, чтобы ловить shake-события,
        // но отключим захват тачей через хит-тест (ниже).
        win.makeKey()
        // и просим стать firstResponder для получения motion-событий
        _ = win.becomeFirstResponder()

        detectorWindow = win
    }

    /// Показать меню поверх всего UI
    @MainActor
    public func show() {
        guard overlayWindow == nil,
              let scene = Self.activeWindowScene() else { return }

        let window = UIWindow(windowScene: scene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        window.rootViewController = DebugMenuContainerVC()
        window.isHidden = false
        overlayWindow = window
    }

    /// Спрятать меню
    @MainActor
    public func hide() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }

    /// Переключить состояние
    @MainActor
    public func toggle() {
        if overlayWindow == nil { show() } else { hide() }
    }

    // MARK: - Internal handlers

    @objc private func handleThreeFingerSwipe(_ recognizer: UISwipeGestureRecognizer) {
        // Любой трехпальцевый свайп — переключаем меню
        toggle()
    }

    // MARK: - Helpers

    /// Активная foreground-сцена (поддержка multi-scene)
    private static func activeWindowScene() -> UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }
}

// MARK: - Прозрачное окно-детектор
private final class DetectorWindow: UIWindow {

    // Не перехватываем тачи приложения:
    // пропускаем хит-тест, чтобы все события ушли в основные окна
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool { false }

    // Разрешаем получать shake-события
    override var canBecomeFirstResponder: Bool { true }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        Task { @MainActor in
            DebugMenuSDK.shared.toggle()
        }
    }
}

// MARK: - UI меню
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
