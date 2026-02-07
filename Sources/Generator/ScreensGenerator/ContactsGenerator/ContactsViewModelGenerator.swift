import SwiftUI
import Combine
import Contacts

final class ContactsViewModelGenerator: ObservableObject {
    private let contactsService: ContactsServiceGenerator = ContactsServiceImpl()
    
    @Published public var allContacts: [ContactEntity] = []
    @Published public var state: ContactsActionState = .readyToGo
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
    @Published var duplicateGroupsCount: String = "1"
    @Published var duplicatesPerGroup: String = "2"

    enum DuplicateType: Hashable {
        case name, number, email
    }

    @Published var duplicateTypeSelections: Set<DuplicateType> = [.name]
    
    @Published var incompleteNumbersSelected: Bool = true
    @Published var incompleteNamesSelected: Bool = false
    
    @Published var customName: String = ""
    @Published var customSurname: String = ""
    @Published var customNumber: String = ""
    @Published var customEmail: String = ""
    @Published var customCount: String = "1"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
    }
    
    func updateDuplicateSelection(type: DuplicateType, isOn: Bool) {
        if isOn {
            duplicateTypeSelections.insert(type)
        } else {
            if duplicateTypeSelections.count > 1 {
                duplicateTypeSelections.remove(type)
            }
            // else do nothing: always keep at least one selected
        }
    }
}
