import UIKit
import SwiftUI

// MARK: - Menu UI
final class DebugMenuViewController: UIViewController {
    private let items = DebugMenuItem.allCases
    private weak var delegate: (any DebugMenuActionDelegate)?
    
    init(delegate: (any DebugMenuActionDelegate)?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
        
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

extension DebugMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch item.type {
        case .button:
            cell.textLabel?.text = item.title
            cell.accessoryView = nil
            cell.selectionStyle = .default
        case .toggle:
            cell.textLabel?.text = item.title
            let toggle = UISwitch()
            let store = DebugMenuUserDefaultsService.shared
            switch item {
            case .simulatePremium:
                toggle.isOn = store.simulatePremium
            case .simulatePurchase:
                toggle.isOn = store.simulatePurchase
            case .simulateNegativeFlow:
                toggle.isOn = store.simulateNegativeFlow
            case .simulateMissingAdaptyProduct:
                toggle.isOn = store.simulateMissingAdaptyProduct
            case .simulateSplashError:
                toggle.isOn = store.simulateSplashError
            case .setSpecialOfferTimer10s:
                toggle.isOn = store.shouldSetSpecialOfferTimer
            case .setSecurityCenterTimer3m:
                toggle.isOn = store.shouldSetSecurityCenterTimer
            case .simulateOldVersioniOS:
                toggle.isOn = store.simulateOldiOSVersion
            default:
                toggle.isOn = false
            }
            toggle.tag = indexPath.row
            toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
            cell.accessoryView = toggle
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    // MARK: - Menu actions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard item.type == .button else { return }
        
        switch item {
        case .crash: delegate?.didTapCrash()
        case .resetOnboarding: delegate?.didTapResetOnboarding()
        case .openGeneratorApp: delegate?.didTapOpenGeneratorApp()
        case .resetTutorialsForFeatures: delegate?.didTapResetTutorialsForFeatures()
        case .setEmailForTesting: delegate?.showSetEmailAlert(on: self)
        default: break
        }
    }
    
    @objc private func toggleChanged(_ sender: UISwitch) {
        let item = items[sender.tag]
        switch item {
        case .simulatePremium: delegate?.simulatePremium(sender.isOn)
        case .simulatePurchase: delegate?.simulatePurchase(sender.isOn)
        case .simulateNegativeFlow: delegate?.simulateNegativeFlow(sender.isOn)
        case .simulateMissingAdaptyProduct: delegate?.simulateMissingAdaptyProduct(sender.isOn)
        case .simulateSplashError: delegate?.simulateSplashError(sender.isOn)
        case .setSpecialOfferTimer10s: delegate?.setSpecialOfferTimer(sender.isOn)
        case .setSecurityCenterTimer3m: delegate?.setSecurityCenterTimer(sender.isOn)
        case .simulateOldVersioniOS: delegate?.simulateOldiOSVersion(sender.isOn)
        default: break
        }
    }
}
