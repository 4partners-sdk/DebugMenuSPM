import UIKit
import Contacts

typealias ContactEntity = CNContact

protocol ContactsServiceGenerator {
    func requestAccess() async -> Bool
    
    func createContact(
        name: String,
        surname: String,
        phoneNumber: String,
        email: String
    ) async throws
}

final class ContactsServiceImpl: ContactsServiceGenerator {
    private let contactsStore = CNContactStore()
}

extension ContactsServiceImpl {
    public func createContact(
        name: String,
        surname: String,
        phoneNumber: String,
        email: String
    ) async throws {
        let contact = CNMutableContact()
        contact.givenName = name
        contact.familyName = surname
        
        if !phoneNumber.isEmpty {
            let phone = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))
            contact.phoneNumbers = [phone]
        }
        
        if !email.isEmpty {
            let emailValue = CNLabeledValue(label: CNLabelHome, value: email as NSString)
            contact.emailAddresses = [emailValue]
        }
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try contactsStore.execute(saveRequest)
        } catch {
            throw error
        }
    }
}

extension ContactsServiceImpl {
    public func requestAccess() async -> Bool {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        switch authorizationStatus {
        case .authorized: return true
        case .limited, .restricted, .denied:
            openSettings()
            return false
        case .notDetermined:
            do {
                let accessGranted = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
                    contactsStore.requestAccess(for: CNEntityType.contacts) { accessGranted, error in
                        if let error { continuation.resume(throwing: error) }
                        else { continuation.resume(returning: accessGranted) }
                    }
                }
                return accessGranted
            } catch {
                return false
            }
        @unknown default: return false
        }
    }
    
    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}
