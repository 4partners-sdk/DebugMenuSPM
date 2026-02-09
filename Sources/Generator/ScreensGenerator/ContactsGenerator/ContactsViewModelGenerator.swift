import SwiftUI
import Combine
import Contacts

@MainActor
final class ContactsViewModelGenerator: ObservableObject {
    private let contactsService: ContactsServiceGenerator = ContactsServiceImpl()
    
    @Published public var allContacts: [ContactEntity] = []
    @Published public var state: ContactsActionState = .readyToGo
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
    @Published var allNumberOfCount = "1"
    @Published var allAllowDuplicates = true
    
    @Published var duplicateGroupsCount: String = "1"
    @Published var duplicatesPerGroup: String = "2"
    
    @Published var duplicateTypeSelections: Set<DuplicateType> = [.name, .number]
    
    @Published var incompleteCount: String = "1"
    @Published var incompleteNumbersSelected: Bool = true
    @Published var incompleteNamesSelected: Bool = false
    
    @Published var customName: String = ""
    @Published var customSurname: String = ""
    @Published var customNumber: String = ""
    @Published var customEmail: String = ""
    @Published var customCount: String = "1"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        contactsService.allContactsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contacts in
                self?.allContacts = contacts
            }
            .store(in: &cancellables)
        
        Task {
            isLoading = true; defer { isLoading = false }
            if await contactsService.requestAccess() {
                do {
                    try await contactsService.fetchAll()
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    public func createGeneralContacts() {
        if let count = Int(allNumberOfCount), count >= 1 {
            Task {
                isLoading = true; defer { isLoading = false }
                state = .creatingContacts(count: count)
                
                do {
                    try await contactsService.createGeneralContacts(
                        count: count,
                        allowDuplicates: allAllowDuplicates
                    )
                    state = .readyToGo
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    public func createDuplicateContacts() {
        if let groupCount = Int(duplicateGroupsCount), groupCount >= 1,
           let perGroupCount = Int(duplicatesPerGroup), perGroupCount >= 2 {
            Task {
                isLoading = true; defer { isLoading = false }
                state = .creatingContacts(count: groupCount * perGroupCount)
                
                do {
                    try await contactsService.createDuplicateContacts(
                        groupsCount: groupCount,
                        duplicatesPerGroup: perGroupCount,
                        duplicateTypeSelections: duplicateTypeSelections
                    )
                    state = .readyToGo
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    public func createIncompleteContacts() {
        if let count = Int(incompleteCount), count >= 1 {
            Task {
                isLoading = true; defer { isLoading = false }
                state = .creatingContacts(count: count)
                
                do {
                    try await contactsService.createIncompleteContacts(
                        count: count,
                        isIncompleteNumber: incompleteNumbersSelected
                    )
                    state = .readyToGo
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    public func createCustomContacts() {
        if let count = Int(customCount), count >= 1, customName != "" {
            Task {
                isLoading = true; defer { isLoading = false }
                state = .creatingContacts(count: count)
                
                do {
                    try await contactsService.createCustomContacts(
                        count: count,
                        name: customName,
                        surname: customSurname,
                        phoneNumber: customNumber,
                        email: customEmail
                    )
                    state = .readyToGo
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    public func deleteAll() {
        Task {
            isLoading = true; defer { isLoading = false }
            state = .deletingAllContacts
            
            do {
                try await contactsService.deleteAll()
                state = .readyToGo
            } catch {
                self.error = error
            }
        }
    }
    
    func updateDuplicateSelection(type: DuplicateType, isOn: Bool) {
        if isOn {
            duplicateTypeSelections.insert(type)
        } else {
            if duplicateTypeSelections.count > 1 {
                duplicateTypeSelections.remove(type)
            }
        }
    }
}
