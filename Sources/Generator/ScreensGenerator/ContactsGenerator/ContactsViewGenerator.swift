import SwiftUI

struct ContactsView: View {
    
    @ObservedObject var viewModel = ContactsViewModelGenerator()
    
    @State private var info = "...info..."
    @State private var name = ""
    @State private var surname = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var numberOfContacts = "1"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                // Info Text
                Text(info)
                
                // Text Fields
                Group {
                    TextField("Name", text: $name)
                    
                    TextField("Surname", text: $surname)
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.numberPad)
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    
                    TextField("Number of Contacts", text: $numberOfContacts)
                        .keyboardType(.numberPad)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .padding(.horizontal)
                
                // Duplicate Buttons
                Group {
                    Button(action: { createDuplicateNames() }) {
                        Text("Create \(numberOfContacts) Duplicate Names")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: { createDuplicateNumbers() }) {
                        Text("Create \(numberOfContacts) Duplicate Numbers")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: { createDuplicateEmails() }) {
                        Text("Create \(numberOfContacts) Duplicate Emails")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 25)
                
                // Incomplete Buttons
                Group {
                    Button(action: { createIncompleteNames() }) {
                        Text("Create \(numberOfContacts) Incomplete Names")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: { createIncompleteNumbers() }) {
                        Text("Create \(numberOfContacts) Incomplete Numbers")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 25)
                
                // Random Button
                Button(action: { createRandomContacts() }) {
                    Text("Generate \(numberOfContacts) Random Contacts")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 25)
                
                Spacer()
            }
            .padding(.top, 10)
        }
        .background(Color(UIColor.systemGray6))
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            Task { @MainActor in _ = await viewModel.requestAccess() }
        }
    }
    
}

extension ContactsView {
    private func createDuplicateNames() {
        Task { @MainActor in
            do {
                info = "creating duplicate names"
                if name == "" { info = "missing name"; return }
                
                let numberOfContacts = Int(numberOfContacts) ?? 1
                for _ in 1...numberOfContacts {
                    let surname = (surname == "" ? viewModel.getRandomSurname() : surname)
                    let phoneNumber = (phoneNumber == "" ? viewModel.getRandomNumber() : phoneNumber)
                    let email = (email == "" ? viewModel.getRandomEmail() : email)
                    try await viewModel.createContact(
                        name: name,
                        surname: surname,
                        phoneNumber: phoneNumber,
                        email: email)
                }
                
                info = "successfully created \(numberOfContacts) duplicate names"
            } catch {
                info = error.localizedDescription
            }
        }
    }
    
    private func createDuplicateNumbers() {
        Task { @MainActor in
            do {
                info = "creating duplicate numbers"
                if phoneNumber == "" { info = "missing phone number"; return }
                
                let numberOfContacts = Int(numberOfContacts) ?? 1
                for _ in 1...numberOfContacts {
                    let name = (name == "" ? viewModel.getRandomName() : name)
                    let surname = (surname == "" ? viewModel.getRandomSurname() : surname)
                    let email = (email == "" ? viewModel.getRandomEmail() : email)
                    try await viewModel.createContact(
                        name: name,
                        surname: surname,
                        phoneNumber: phoneNumber,
                        email: email)
                }
                
                info = "successfully created \(numberOfContacts) duplicate numbers"
            } catch {
                info = error.localizedDescription
            }
        }
    }
    
    private func createDuplicateEmails() {
        Task { @MainActor in
            do {
                info = "creating duplicate emails"
                if email == "" { info = "missing email"; return }
                
                let numberOfContacts = Int(numberOfContacts) ?? 1
                for _ in 1...numberOfContacts {
                    let name = (name == "" ? viewModel.getRandomName() : name)
                    let surname = (surname == "" ? viewModel.getRandomSurname() : surname)
                    let phoneNumber = (phoneNumber == "" ? viewModel.getRandomNumber() : phoneNumber)
                    try await viewModel.createContact(
                        name: name,
                        surname: surname,
                        phoneNumber: phoneNumber,
                        email: email)
                }
                
                info = "successfully created \(numberOfContacts) duplicate emails"
            } catch {
                info = error.localizedDescription
            }
        }
    }
    
    private func createIncompleteNames() {
        Task { @MainActor in
            do {
                info = "creating incomplete names"
                if phoneNumber == "" { info = "missing number"; return }
                
                let numberOfContacts = Int(numberOfContacts) ?? 1
                for _ in 1...numberOfContacts {
                    try await viewModel.createContact(
                        name: "",
                        surname: "",
                        phoneNumber: phoneNumber,
                        email: email)
                }
                
                info = "successfully created \(numberOfContacts) incomplete names"
            } catch {
                info = error.localizedDescription
            }
        }
    }
    
    private func createIncompleteNumbers() {
        Task { @MainActor in
            do {
                info = "creating incomplete numbers"
                if name == "" { info = "missing name"; return }
                
                let numberOfContacts = Int(numberOfContacts) ?? 1
                for _ in 1...numberOfContacts {
                    let surname = (surname == "" ? viewModel.getRandomSurname() : surname)
                    try await viewModel.createContact(
                        name: name,
                        surname: surname,
                        phoneNumber: "",
                        email: email)
                }
                
                info = "successfully created \(numberOfContacts) incomplete numbers"
            } catch {
                info = error.localizedDescription
            }
        }
    }
    
    private func createRandomContacts() {
        Task { @MainActor in
            do {
                info = "creating random contacts"
                
                let numberOfContacts = Int(numberOfContacts) ?? 1
                for _ in 1...numberOfContacts {
                    try await viewModel.createContact(
                        name: viewModel.getRandomName(),
                        surname: viewModel.getRandomSurname(),
                        phoneNumber: viewModel.getRandomNumber(),
                        email: viewModel.getRandomEmail())
                }
                
                info = "successfully created \(numberOfContacts) random contacts"
            } catch {
                info = error.localizedDescription
            }
        }
    }
}
