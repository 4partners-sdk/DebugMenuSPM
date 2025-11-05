import SwiftUI
import Contacts

final class ContactsViewModelGenerator: ObservableObject {
    
    private let contactsService: ContactsServiceGenerator = ContactsServiceImpl()
    
    public func requestAccess() async -> Bool {
        await contactsService.requestAccess()
    }
    
    public func createContact(
        name: String,
        surname: String,
        phoneNumber: String,
        email: String
    ) async throws {
        try await contactsService.createContact(
            name: name,
            surname: surname,
            phoneNumber: phoneNumber,
            email: email)
    }
    
    public func getRandomName() -> String {
        return ContactsModelGenerator.names.randomElement() ?? "Name"
    }
    
    public func getRandomSurname() -> String {
        return ContactsModelGenerator.surnames.randomElement() ?? "Surname"
    }
    
    public func getRandomNumber() -> String {
        return ContactsModelGenerator.phoneNumbers.randomElement() ?? "000-000-0000"
    }
    
    public func getRandomEmail() -> String {
        return ContactsModelGenerator.emails.randomElement() ?? "unknown@example.com"
    }
    
}
