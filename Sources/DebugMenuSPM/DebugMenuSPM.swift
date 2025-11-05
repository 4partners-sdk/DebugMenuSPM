import UIKit
import SwiftUI

// MARK: - DebugMenuService
public class DebugMenuService: DebugMenuDelegate {
    public static let shared = DebugMenuService()
    
    public var minimumiOSVersion: String = "17.0"
    public var resetOnboarding: (() -> Void)?
    public var resetTutorialsForFeatures: (() -> Void)?
    
    private(set) var simulatePremium: Bool
    private(set) var simulatePurchase: Bool
    private(set) var simulateNegativeFlow: Bool
    private(set) var simulateMissingAdaptyProduct: Bool
    private(set) var simulateSplashError: Bool
    private(set) var shouldSetSpecialOfferTimer10s: Bool
    private(set) var shouldSetSecurityCenterTimer3m: Bool
    private(set) var shouldSetOldiOSVersion: Bool
    private(set) var emailForCheck: String = ""
    private let innerHandler: DebugMenuInnerDelegate = DebugMenuInnerHandler()
    private let store = DebugMenuUserDefaultsService.shared
    private var gesture: UISwipeGestureRecognizer?
    private var isPresenting = false
    
    // MARK: - init
    private init() {
        simulatePremium = store.simulatePremium
        simulatePurchase = store.simulatePurchase
        simulateNegativeFlow = store.simulateNegativeFlow
        simulateMissingAdaptyProduct = store.simulateMissingAdaptyProduct
        simulateSplashError = store.simulateSplashError
        shouldSetSpecialOfferTimer10s = store.shouldSetSpecialOfferTimer
        shouldSetSecurityCenterTimer3m = store.shouldSetSecurityCenterTimer
        shouldSetOldiOSVersion = store.simulateOldiOSVersion
        emailForCheck = store.emailForCheck
    }
    
    public func start() {
        setupShakeDetection()
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.attachGestureRecognizer()
        }
    }
}

// MARK: - Private
private extension DebugMenuService {
    func setupShakeDetection() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        rootViewController.becomeFirstResponder()
    }
    
    func attachGestureRecognizer() {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
        else { return }
        
        if let gesture {
            keyWindow.removeGestureRecognizer(gesture)
        }
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(triggerMenu))
        gesture.direction = .up
        gesture.numberOfTouchesRequired = 3
        gesture.cancelsTouchesInView = false
        
        keyWindow.addGestureRecognizer(gesture)
        self.gesture = gesture
    }
    
    func presentMenu(from presenter: UIViewController) {
        guard !isPresenting else { return }
        isPresenting = true
        
        let controller = DebugMenuViewController(delegate: self)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        presenter.topMost.present(nav, animated: true) { [weak self] in
            self?.isPresenting = false
        }
    }
    
    @objc
    func triggerMenu() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else { return }
        
        presentMenu(from: root.topMost)
    }
}

// MARK: - DebugMenuActionDelegate
extension DebugMenuService: DebugMenuActionDelegate {
    func didTapCrash() {
        innerHandler.didTapCrash()
    }
    
    func didTapResetOnboarding() {
        resetOnboarding?()
    }
    
    func didTapResetTutorialsForFeatures() {
        resetTutorialsForFeatures?()
    }
    
    func simulatePremium(_ isOn: Bool) {
        simulatePremium = isOn
        store.simulatePremium = isOn
    }
    
    func simulatePurchase(_ isOn: Bool) {
        simulatePurchase = isOn
        store.simulatePurchase = isOn
    }
    
    func simulateNegativeFlow(_ isOn: Bool) {
        simulateNegativeFlow = isOn
        store.simulateNegativeFlow = isOn
    }
    
    func simulateMissingAdaptyProduct(_ isOn: Bool) {
        simulateMissingAdaptyProduct = isOn
        store.simulateMissingAdaptyProduct = isOn
    }
    
    func simulateSplashError(_ isOn: Bool) {
        simulateSplashError = isOn
        store.simulateSplashError = isOn
    }
    
    func simulateOldiOSVersion(_ isOn: Bool) {
        shouldSetOldiOSVersion = isOn
        store.simulateOldiOSVersion = isOn
    }
    
    func setSpecialOfferTimer(_ isOn: Bool) {
        shouldSetSpecialOfferTimer10s = isOn
        store.shouldSetSpecialOfferTimer = isOn
    }
    
    func setSecurityCenterTimer(_ isOn: Bool) {
        shouldSetSecurityCenterTimer3m = isOn
        store.shouldSetSecurityCenterTimer = isOn
    }
    
    func showSetEmailAlert(on viewController: UIViewController) {
        innerHandler.showSetEmailAlert(viewController) { [weak self] email in
            self?.emailForCheck = email
        }
    }
    
    func didTapOpenGeneratorApp() {
        innerHandler.didTapOpenGeneratorApp()
    }
}

// MARK: - Shake Detection
extension UIViewController {
    open override var canBecomeFirstResponder: Bool { true }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            DebugMenuService.shared.triggerMenu()
        }
    }
}
