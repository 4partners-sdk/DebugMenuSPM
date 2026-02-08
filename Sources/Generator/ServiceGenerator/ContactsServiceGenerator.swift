import UIKit
import Combine
import Contacts

typealias ContactEntity = CNContact

protocol ContactsServiceGenerator {
    var allContactsPublisher: AnyPublisher<[ContactEntity], Never> { get }
    
    func requestAccess() async -> Bool
    func fetchAll() async throws
    func deleteAll() async throws
    
    func createGeneralContacts(
        count: Int,
        allowDuplicates: Bool
    ) async throws
    func createDuplicateContacts(
        groupsCount: Int,
        duplicatesPerGroup: Int,
        duplicateTypeSelections: Set<DuplicateType>
    ) async throws
    func createIncompleteContacts(
        count: Int,
        isIncompleteNumber: Bool
    ) async throws
    func createCustomContacts(
        count: Int,
        name: String,
        surname: String,
        phoneNumber: String,
        email: String
    ) async throws
}

final class ContactsServiceImpl: ContactsServiceGenerator {
    private enum Const {
        static let keysToFetch: [CNKeyDescriptor] = [
            CNContactIdentifierKey as CNKeyDescriptor,
            CNContactNamePrefixKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPreviousFamilyNameKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactMiddleNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPostalAddressesKey as CNKeyDescriptor,
            CNContactNameSuffixKey as CNKeyDescriptor,
            CNContactNicknameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
    }
    
    private let contactsStore = CNContactStore()
    
    @Published private var allContacts: [ContactEntity] = []
    public var allContactsPublisher: AnyPublisher<[ContactEntity], Never> {
        $allContacts.eraseToAnyPublisher()
    }
}

extension ContactsServiceImpl {
    public func fetchAll() async throws {
        let request: CNContactFetchRequest = {
            let request = CNContactFetchRequest(keysToFetch: Const.keysToFetch)
            return request
        }()
        
        do {
            var collectedContacts: [ContactEntity] = []
            try self.contactsStore.enumerateContacts(with: request) { cnContact, _ in
                collectedContacts.append(cnContact)
            }
            self.allContacts = collectedContacts
        } catch {
            self.allContacts = []
        }
    }
    
    public func createGeneralContacts(
        count: Int,
        allowDuplicates: Bool
    ) async throws {
        func uniqueName(base: String, index: Int) -> String {
            "\(base) \(index + 1)"
        }
        
        func uniqueSurname(base: String, index: Int) -> String {
            "\(base) \(index + 1)"
        }

        func uniquePhone(base: String, index: Int) -> String {
            let suffix = index % 10_000
            return "\(base)-\(suffix)"
        }
        
        func uniqueEmail(base: String, index: Int) -> String {
            let parts = base.split(separator: "@")
            guard parts.count == 2 else { return base }
            return "\(parts[0])+\(index)@\(parts[1])"
        }
        
        var newContacts: [CNMutableContact] = []
        for i in 0..<count {
            let contact = CNMutableContact()
            
            let name: String
            let surname: String
            let phone: String
            let email: String
            
            if allowDuplicates {
                name = ContactsModelGenerator.names.randomElement() ?? "John"
                surname = ContactsModelGenerator.surnames.randomElement() ?? "Doe"
                phone = ContactsModelGenerator.phoneNumbers.randomElement() ?? "123-456-7890"
                email = ContactsModelGenerator.emails.randomElement() ?? "test@example.com"
            } else {
                let nameBase = ContactsModelGenerator.names[i % ContactsModelGenerator.names.count]
                let surnameBase = ContactsModelGenerator.surnames[i % ContactsModelGenerator.surnames.count]
                let phoneBase = ContactsModelGenerator.phoneNumbers[i % ContactsModelGenerator.phoneNumbers.count]
                let emailBase = ContactsModelGenerator.emails[i % ContactsModelGenerator.emails.count]
                
                name = uniqueName(base: nameBase, index: i)
                surname = uniqueSurname(base: surnameBase, index: i)
                phone = uniquePhone(base: phoneBase, index: i)
                email = uniqueEmail(base: emailBase, index: i)
            }
            
            contact.givenName = name
            contact.familyName = surname
            contact.phoneNumbers = [CNLabeledValue(
                label: CNLabelPhoneNumberMobile,
                value: CNPhoneNumber(stringValue: phone)
            )]
            contact.emailAddresses = [CNLabeledValue(
                label: CNLabelHome,
                value: email as NSString
            )]
            
            newContacts.append(contact)
        }
        
        let saveRequest = CNSaveRequest()
        newContacts.forEach { saveRequest.add($0, toContainerWithIdentifier: nil) }
        
        try contactsStore.execute(saveRequest)
        try await fetchAll()
    }
    
    public func createDuplicateContacts(
        groupsCount: Int,
        duplicatesPerGroup: Int,
        duplicateTypeSelections: Set<DuplicateType>
    ) async throws {
        
        var newContacts: [CNMutableContact] = []
        
        func uniqueSuffix(_ index: Int) -> String {
            return "\(index + 1)"
        }
        
        for groupIndex in 0..<groupsCount {
            let groupName: String = duplicateTypeSelections.contains(.name)
            ? "\(ContactsModelGenerator.names.randomElement() ?? "Name") \(groupIndex)"
            : ""
            
            let groupNumber: String = duplicateTypeSelections.contains(.number)
            ? "\(ContactsModelGenerator.phoneNumbers.randomElement() ?? "000-000-0000")-\(groupIndex)"
            : ""
            
            let groupEmail: String = duplicateTypeSelections.contains(.email)
            ? {
                let base = ContactsModelGenerator.emails.randomElement() ?? "test@example.com"
                let parts = base.split(separator: "@")
                guard parts.count == 2 else { return base }
                return "\(parts[0])+\(groupIndex)@\(parts[1])"
            }()
            : ""
            
            for contactIndex in 0..<duplicatesPerGroup {
                
                let contact = CNMutableContact()
                
                contact.givenName = duplicateTypeSelections.contains(.name)
                ? groupName
                : "\(ContactsModelGenerator.names.randomElement() ?? "Name") \(groupIndex)-\(contactIndex)"
                
                contact.familyName = "\(ContactsModelGenerator.surnames.randomElement() ?? "Surname") \(groupIndex)-\(contactIndex)"
                
                contact.phoneNumbers = {
                    if duplicateTypeSelections.contains(.number) {
                        let phone = CNLabeledValue(
                            label: CNLabelPhoneNumberMobile,
                            value: CNPhoneNumber(stringValue: groupNumber)
                        )
                        return [phone]
                    } else {
                        let uniquePhone = "\(ContactsModelGenerator.phoneNumbers.randomElement() ?? "000-000-0000")-\(groupIndex)-\(contactIndex)"
                        let phone = CNLabeledValue(
                            label: CNLabelPhoneNumberMobile,
                            value: CNPhoneNumber(stringValue: uniquePhone)
                        )
                        return [phone]
                    }
                }()
                
                contact.emailAddresses = {
                    if duplicateTypeSelections.contains(.email) {
                        let emailValue = CNLabeledValue(label: CNLabelHome, value: groupEmail as NSString)
                        return [emailValue]
                    } else {
                        let baseEmail = ContactsModelGenerator.emails.randomElement() ?? "test@example.com"
                        let parts = baseEmail.split(separator: "@")
                        let uniqueEmail: String
                        if parts.count == 2 {
                            uniqueEmail = "\(parts[0])+\(groupIndex)-\(contactIndex)@\(parts[1])"
                        } else {
                            uniqueEmail = baseEmail
                        }
                        let emailValue = CNLabeledValue(label: CNLabelHome, value: uniqueEmail as NSString)
                        return [emailValue]
                    }
                }()
                
                newContacts.append(contact)
            }
        }
        
        let saveRequest = CNSaveRequest()
        newContacts.forEach { saveRequest.add($0, toContainerWithIdentifier: nil) }
        try contactsStore.execute(saveRequest)
        try await fetchAll()
    }
    
    public func createIncompleteContacts(
        count: Int,
        isIncompleteNumber: Bool
    ) async throws {
        func uniqueName(base: String, index: Int) -> String {
            "\(base) \(index + 1)"
        }
        
        func uniqueSurname(base: String, index: Int) -> String {
            "\(base) \(index + 1)"
        }
        
        func uniquePhone(base: String, index: Int) -> String {
            let suffix = index % 10_000
            return "\(base)-\(suffix)"
        }
        
        var newContacts: [CNMutableContact] = []
        
        for i in 0..<count {
            let contact = CNMutableContact()
            
            if isIncompleteNumber {
                let nameBase = ContactsModelGenerator.names[i % ContactsModelGenerator.names.count]
                let surnameBase = ContactsModelGenerator.surnames[i % ContactsModelGenerator.surnames.count]
                
                contact.givenName = uniqueName(base: nameBase, index: i)
                contact.familyName = uniqueSurname(base: surnameBase, index: i)
            } else {
                let phoneBase = ContactsModelGenerator.phoneNumbers[i % ContactsModelGenerator.phoneNumbers.count]
                let uniquePhone = uniquePhone(base: phoneBase, index: i)
                
                contact.phoneNumbers = [CNLabeledValue(
                    label: CNLabelPhoneNumberMobile,
                    value: CNPhoneNumber(stringValue: uniquePhone)
                )]
            }
            
            newContacts.append(contact)
        }
        
        let saveRequest = CNSaveRequest()
        newContacts.forEach { saveRequest.add($0, toContainerWithIdentifier: nil) }
        
        try contactsStore.execute(saveRequest)
        try await fetchAll()
    }
    
    public func createCustomContacts(
        count: Int,
        name: String,
        surname: String,
        phoneNumber: String,
        email: String
    ) async throws {
        let request = CNSaveRequest()
        
        for _ in 0..<count {
            let contact = CNMutableContact()
            
            contact.givenName = name
            contact.familyName = surname
            
            if !phoneNumber.isEmpty {
                let phone = CNLabeledValue(
                    label: CNLabelPhoneNumberMobile,
                    value: CNPhoneNumber(stringValue: phoneNumber)
                )
                contact.phoneNumbers = [phone]
            }
            
            if !email.isEmpty {
                let emailValue = CNLabeledValue(
                    label: CNLabelHome,
                    value: email as NSString
                )
                contact.emailAddresses = [emailValue]
            }
            
            request.add(contact, toContainerWithIdentifier: nil)
        }
        
        try contactsStore.execute(request)
        try await fetchAll()
    }
    
    public func deleteAll() async throws {
        let request = CNSaveRequest()
        
        for contact in allContacts {
            let cnContact = try contactsStore.unifiedContact(
                withIdentifier: contact.identifier,
                keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor]
            )
            
            if let mutableCopy = cnContact.mutableCopy() as? CNMutableContact {
                request.delete(mutableCopy)
            }
        }
        
        try contactsStore.execute(request)
        allContacts = []
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
