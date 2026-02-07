import SwiftUI

struct ContactsView: View {
    
    @ObservedObject var viewModel = ContactsViewModelGenerator()
    
    // UI State
    @State private var numberOfContacts = "1"
    @State private var allowDuplicates = true
    @State private var selectedSegment = 0
    
    private let segments = ["General", "Duplicates", "Incomplete", "Custom"]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    Text("All contacts in device: \(viewModel.allContacts.count)")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    // Info text
                    Text(viewModel.state.title)
                        .multilineTextAlignment(.center)
                    
                    // Segmented Control
                    Picker("Section", selection: $selectedSegment) {
                        ForEach(0..<segments.count, id: \.self) { index in
                            Text(segments[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Section Views
                    VStack(spacing: 12) {
                        switch selectedSegment {
                        case 0: // General
                            generalSection
                        case 1: // Duplicates
                            duplicatesSection
                        case 2: // Incomplete
                            incompleteSection
                        case 3: // Custom
                            customSection
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            
            ZStack {
                if viewModel.isLoading {
                    LoaderView().transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6))
        .errorAlert(error: $viewModel.error)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension ContactsView {
    private var generalSection: some View {
        VStack(spacing: 12) {
            TextField("Number of Contacts", text: $numberOfContacts)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            Toggle("Allow Duplicates", isOn: $allowDuplicates)
                .padding(.horizontal)
            
            Button {
                
            } label: {
                Text("Generate \(numberOfContacts) Contacts")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    private var incompleteSection: some View {
        VStack(spacing: 12) {
            // Number of contacts
            TextField("Number of Contacts", text: $numberOfContacts)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            // Mutually exclusive toggles (always one selected)
            VStack(spacing: 8) {
                Toggle("Incomplete Number:", isOn: Binding(
                    get: { viewModel.incompleteNumbersSelected },
                    set: { newValue in
                        if newValue {
                            // user selected this toggle
                            viewModel.incompleteNumbersSelected = true
                            viewModel.incompleteNamesSelected = false
                        } else {
                            // user tried to unselect, switch to the other toggle
                            viewModel.incompleteNumbersSelected = false
                            viewModel.incompleteNamesSelected = true
                        }
                    }
                ))
                
                Toggle("Incomplete Name:", isOn: Binding(
                    get: { viewModel.incompleteNamesSelected },
                    set: { newValue in
                        if newValue {
                            viewModel.incompleteNamesSelected = true
                            viewModel.incompleteNumbersSelected = false
                        } else {
                            viewModel.incompleteNamesSelected = false
                            viewModel.incompleteNumbersSelected = true
                        }
                    }
                ))
            }
            .padding(.horizontal)
            
            // Generate button
            Button {
                
            } label: {
                Text("Generate \(numberOfContacts) Incomplete Contacts")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    private var duplicatesSection: some View {
        VStack(spacing: 12) {
            // Counts
            HStack {
                TextField("Groups", text: $viewModel.duplicateGroupsCount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Contacts Per Group", text: $viewModel.duplicatesPerGroup)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Mutually exclusive toggles
            VStack(spacing: 8) {
                Toggle("Duplicate Name:", isOn: Binding(
                    get: { viewModel.duplicateTypeSelections.contains(.name) },
                    set: { newValue in
                        viewModel.updateDuplicateSelection(type: .name, isOn: newValue)
                    }
                ))
                
                Toggle("Duplicate Number:", isOn: Binding(
                    get: { viewModel.duplicateTypeSelections.contains(.number) },
                    set: { newValue in
                        viewModel.updateDuplicateSelection(type: .number, isOn: newValue)
                    }
                ))
                
                Toggle("Duplicate Email:", isOn: Binding(
                    get: { viewModel.duplicateTypeSelections.contains(.email) },
                    set: { newValue in
                        viewModel.updateDuplicateSelection(type: .email, isOn: newValue)
                    }
                ))
            }
            .padding(.horizontal)
            
            // Generate button
            Button {
                
            } label: {
                Text("Generate \(viewModel.duplicateGroupsCount) groups × \(viewModel.duplicatesPerGroup) contacts each")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    private var customSection: some View {
        VStack(spacing: 12) {
            // Optional fields
            Group {
                TextField("Name (optional)", text: $viewModel.customName)
                TextField("Surname (optional)", text: $viewModel.customSurname)
                TextField("Phone Number (optional)", text: $viewModel.customNumber)
                    .keyboardType(.numberPad)
                TextField("Email (optional)", text: $viewModel.customEmail)
                    .keyboardType(.emailAddress)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            
            // Count field
            TextField("Number of Contacts", text: $viewModel.customCount)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Generate button
            Button {
                
            } label: {
                Text("Generate \(viewModel.customCount) Contacts")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
