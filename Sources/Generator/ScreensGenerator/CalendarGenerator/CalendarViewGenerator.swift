import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel = CalendarViewModelGenerator()
    
    @State private var numberOfEvents = "1"
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                
                // Show total events
                Text("All events in device: \(viewModel.allEvents.count)")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                // Info text
                Text(viewModel.state.title)
                    .multilineTextAlignment(.center)
                
                // Number of events text field
                TextField("Number of Events", text: $numberOfEvents)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal)
                
                // Start and End DatePickers
                VStack(spacing: 12) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal)
                    
                    DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal)
                }
                
                // Generate button
                Button {
                    viewModel.createEvents(count: Int(numberOfEvents) ?? 1, startDate: startDate, endDate: endDate)
                } label: {
                    Text("Generate \(numberOfEvents) Events")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 25)
                
                // Delete all events button
                Button {
                    viewModel.deleteAll()
                } label: {
                    Text("Delete All Events")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 25)
                
                Spacer()
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
