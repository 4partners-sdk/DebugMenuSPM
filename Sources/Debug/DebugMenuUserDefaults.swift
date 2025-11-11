import Foundation

public protocol DebugMenuUserDefaultsProviding {
    var simulatePremium: Bool { get set }
    var simulatePurchase: Bool { get set }
    var simulateNegativeFlow: Bool { get set }
    var simulateMissingAdaptyProduct: Bool { get set }
    var simulateSplashError: Bool { get set }
    var shouldSetSpecialOfferTimer: Bool { get set }
    var shouldSetSecurityCenterTimer: Bool { get set }
    var simulateOldiOSVersion: Bool { get set }
    var emailForCheck: String { get set }
}

public enum DebugMenuUserDefaultsKey: String {
    case simulatePremium
    case simulatePurchase
    case simulateNegativeFlow
    case simulateMissingAdaptyProduct
    case simulateSplashError
    case shouldSetSpecialOfferTimer
    case shouldSetSecurityCenterTimer
    case emailForCheck
    case shouldSetOldiOSVersion
    
    var raw: String {
        return self.rawValue
    }
}

public class DebugMenuUserDefaultsService: DebugMenuUserDefaultsProviding {
    public static let shared = DebugMenuUserDefaultsService()
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    public var simulatePremium: Bool {
        get { defaults.bool(forKey: DebugMenuUserDefaultsKey.simulatePremium.raw) }
        set { defaults.set(newValue, forKey: DebugMenuUserDefaultsKey.simulatePremium.raw) }
    }
    
    public var simulatePurchase: Bool {
        get { defaults.bool(forKey: DebugMenuUserDefaultsKey.simulatePurchase.raw) }
        set { defaults.set(newValue, forKey: DebugMenuUserDefaultsKey.simulatePurchase.raw) }
    }
    
    public var simulateNegativeFlow: Bool {
        get { defaults.bool(forKey: DebugMenuUserDefaultsKey.simulateNegativeFlow.raw) }
        set { defaults.set(newValue, forKey: DebugMenuUserDefaultsKey.simulateNegativeFlow.raw) }
    }
    
    public var simulateMissingAdaptyProduct: Bool {
        get { defaults.bool(forKey: DebugMenuUserDefaultsKey.simulateMissingAdaptyProduct.raw) }
        set { defaults.set(newValue, forKey: DebugMenuUserDefaultsKey.simulateMissingAdaptyProduct.raw) }
    }
    
    public var simulateSplashError: Bool {
        get { defaults.bool(forKey: DebugMenuUserDefaultsKey.simulateSplashError.raw) }
        set { defaults.set(newValue, forKey: DebugMenuUserDefaultsKey.simulateSplashError.raw) }
    }
    
    public var shouldSetSpecialOfferTimer: Bool {
        get { defaults.bool(forKey: DebugMenuUserDefaultsKey.shouldSetSpecialOfferTimer.raw) }
        set { defaults.set(newValue, forKey: DebugMenuUserDefaultsKey.shouldSetSpecialOfferTimer.raw) }
    }
    
    public var shouldSetSecurityCenterTimer: Bool {
        get { defaults.bool(forKey: DebugMenuUserDefaultsKey.shouldSetSecurityCenterTimer.raw) }
        set { defaults.set(newValue, forKey: DebugMenuUserDefaultsKey.shouldSetSecurityCenterTimer.raw) }
    }
    
    public var simulateOldiOSVersion: Bool {
        get { defaults.bool(forKey: DebugMenuUserDefaultsKey.shouldSetOldiOSVersion.raw) }
        set { defaults.set(newValue, forKey: DebugMenuUserDefaultsKey.shouldSetOldiOSVersion.raw) }
    }
    
    public var emailForCheck: String {
        get { defaults.string(forKey: DebugMenuUserDefaultsKey.emailForCheck.raw) ?? "" }
        set { defaults.set(newValue, forKey: DebugMenuUserDefaultsKey.emailForCheck.raw) }
    }
}
