import UIKit
import CoreMotion

public final class DebugMenuSDK {
    public static let shared = DebugMenuSDK()
    private init() {}

    // Окно с меню
    private var overlayWindow: UIWindow?

    // CoreMotion для shake
    private let motion = CMMotionManager()
    private var isShakeArmed = true

    // Подписки на появление новых окон
    private var observers: [NSObjectProtocol] = []

    // MARK: - Public API

    public func enableGlobalTriggers() {
        onMain {
            self.attachSwipeRecognizersToAllWindows()
            self.startShakeDetection()

            // Следим за появлением новых окон и навешиваем на них жесты
            let n1 = NotificationCenter.default.addObserver(
                forName: UIWindow.didBecomeVisibleNotification, object: nil, queue: .main
            ) { [weak self] note in
                guard let w = note.object as? UIWindow else { return }
                self?.attachSwipeRecognizers(to: w)
            }
            let n2 = NotificationCenter.default.addObserver(
                forName: UIScene.willEnterForegroundNotification, object: nil, queue: .main
            ) { [weak self] _ in
                self?.attachSwipeRecognizersToAllWindows()
            }
            self.observers = [n1, n2]
        }
    }

    public func disableGlobalTriggers() {
        onMain { [weak self] in
            self?.observers.forEach { NotificationCenter.default.removeObserver($0) }
            self?.observers.removeAll()
            self?.stopShakeDetection()
            // свайпы останутся на окнах, можно при желании их снимать (опционально)
        }
    }

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

    public func hide() {
        onMain {
            self.overlayWindow?.isHidden = true
            self.overlayWindow = nil
        }
    }

    public func toggle() {
        onMain {
            if self.overlayWindow == nil { self.show() } else { self.hide() }
        }
    }

    // MARK: - Gestures

    private func attachSwipeRecognizersToAllWindows() {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .flatMap { $0.windows }
            .forEach { attachSwipeRecognizers(to: $0) }
    }

    private func attachSwipeRecognizers(to window: UIWindow) {
        // не дублируем, если уже навешаны
        if let existing = window.gestureRecognizers, existing.contains(where: { ($0 as? UISwipeGestureRecognizer)?.name == "DebugMenuSDK.3finger" }) {
            return
        }
        for dir in [UISwipeGestureRecognizer.Direction.up, .down, .left, .right] {
            let g = UISwipeGestureRecognizer(target: self, action: #selector(threeFingerSwiped(_:)))
            g.numberOfTouchesRequired = 3
            g.direction = dir
            g.cancelsTouchesInView = false
            g.name = "DebugMenuSDK.3finger"
            window.addGestureRecognizer(g)
        }
    }

    @objc private func threeFingerSwiped(_ g: UISwipeGestureRecognizer) {
        toggle()
    }

    // MARK: - Shake via CoreMotion

    private func startShakeDetection() {
        guard motion.isAccelerometerAvailable else { return }
        if motion.isAccelerometerActive { return }

        motion.accelerometerUpdateInterval = 1.0 / 60.0

        let threshold: Double = 2.2 // ~2.2g — подбери по вкусу
        motion.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self, let a = data?.acceleration else { return }
            // модуль ускорения
            let g = sqrt(a.x*a.x + a.y*a.y + a.z*a.z)
            if g > threshold && self.isShakeArmed {
                self.isShakeArmed = false
                self.toggle()
                // дебаунс 1 секунду
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isShakeArmed = true
                }
            }
        }
    }

    private func stopShakeDetection() {
        if motion.isAccelerometerActive { motion.stopAccelerometerUpdates() }
    }

    // MARK: - Helpers

    private static func activeWindowScene() -> UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }

    @inline(__always)
    private func onMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread { block() } else { DispatchQueue.main.async { block() } }
    }
}

// MARK: - UI меню (как у тебя)
final class DebugMenuContainerVC: UIViewController {
    private lazy var dimView: UIView = {
        let v = UIView(); v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false; return v
    }()
    private lazy var cardView: UIVisualEffectView = {
        let v = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        v.layer.cornerRadius = 20; v.clipsToBounds = true; v.translatesAutoresizingMaskIntoConstraints = false; return v
    }()
    private lazy var titleLabel: UILabel = {
        let l = UILabel(); l.text = "Debug Menu"; l.textColor = .white
        l.font = .boldSystemFont(ofSize: 20); l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false; return l
    }()
    private lazy var closeButton: UIButton = {
        let b = UIButton(type: .system); b.setTitle("Close", for: .normal)
        b.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false; return b
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

    @objc private func closeTapped() { DebugMenuSDK.shared.hide() }
}
