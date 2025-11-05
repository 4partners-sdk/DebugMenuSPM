import Foundation

// MARK: - Menu Configuration
enum DebugMenuItem: CaseIterable {
    case crash
    case resetOnboarding
    case resetTutorialsForFeatures
    case simulatePremium
    case simulatePurchase
    case simulateNegativeFlow
    case simulateMissingAdaptyProduct
    case simulateSplashError
    case simulateOldVersioniOS
    case setSpecialOfferTimer10s
    case setSecurityCenterTimer3m
    case setEmailForTesting
    case openGeneratorApp
    
    var title: String {
        switch self {
        case .crash: return "Crash App"
        case .resetOnboarding: return "Reset Onboarding"
        case .simulatePurchase: return "Simulate Purchase"
        case .simulatePremium: return "Toggle Premium"
        case .simulateNegativeFlow: return "Negative Flow"
        case .simulateSplashError: return "Simulate Splash Error"
        case .simulateMissingAdaptyProduct: return "Simulate Missing Product"
        case .setSpecialOfferTimer10s: return "Set Special Offer Timer to 10s"
        case .setSecurityCenterTimer3m: return "Set Security Center Timer to 3m"
        case .resetTutorialsForFeatures: return "Reset Tutorials for Features"
        case .setEmailForTesting: return "Set Email for Testing"
        case .simulateOldVersioniOS: return "Simulate Old iOS Version"
        case .openGeneratorApp: return "Open Generator"
        }
    }
    
    var type: DebugMenuItemType {
        switch self {
        case .simulatePremium, .simulatePurchase, .simulateNegativeFlow,
                .simulateMissingAdaptyProduct, .simulateSplashError,
                .setSpecialOfferTimer10s, .setSecurityCenterTimer3m,
                .simulateOldVersioniOS:
            return .toggle
        case .openGeneratorApp: return .button
        default: return .button
        }
    }
}

enum DebugMenuItemType {
    case button
    case toggle
}
