import UIKit

// MARK: - DebugMenuActionHandler
protocol DebugMenuActionDelegate: AnyObject {
    func didTapCrash()
    func didTapResetOnboarding()
    func didTapResetTutorialsForFeatures()
    func simulatePremium(_ isOn: Bool)
    func simulatePurchase(_ isOn: Bool)
    func simulateNegativeFlow(_ isOn: Bool)
    func simulateMissingAdaptyProduct(_ isOn: Bool)
    func simulateSplashError(_ isOn: Bool)
    func setSpecialOfferTimer(_ isOn: Bool)
    func setSecurityCenterTimer(_ isOn: Bool)
    func simulateOldiOSVersion(_ isOn: Bool)
    func showSetEmailAlert(on viewController: UIViewController)
    func didTapOpenGeneratorApp()
}

protocol DebugMenuInnerDelegate: AnyObject {
    func didTapCrash()
    func didTapOpenGeneratorApp()
    func showSetEmailAlert(_ viewController: UIViewController, completion: @escaping (String) -> Void)
}

// MARK: - DebugMenuHandler
protocol DebugMenuDelegate: AnyObject {
    var resetOnboarding: (()->Void)? { get }
    var resetTutorialsForFeatures: (()->Void)? { get }
    var simulatePremium: Bool { get }
    var simulatePurchase: Bool { get }
    var simulateNegativeFlow: Bool { get }
    var simulateMissingAdaptyProduct: Bool { get }
    var simulateSplashError: Bool { get }
    var shouldSetSpecialOfferTimer10s: Bool { get }
    var shouldSetSecurityCenterTimer3m: Bool { get }
    var shouldSetOldiOSVersion: Bool { get }
    var minimumiOSVersion: String { get }
    var emailForCheck: String { get }
}
