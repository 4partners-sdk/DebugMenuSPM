import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var viewModel = CalendarViewModelGenerator()
    
    @State private var info = "...info..."
    @State private var numberOfEvents = "1"
    @State private var isForFuture = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Info text
            Text(info)
                .padding(.top)
            
            // Text Field
            TextField("Number of Events", text: $numberOfEvents)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .padding(.horizontal)
            
            // Toggle for future/past events
            Toggle(isOn: $isForFuture) {
                Text(isForFuture ? "Create future events" : "Create past events")
            }
            .padding(.horizontal)
            
            // Action Button
            Button{
                Task { @MainActor in
                    do {
                        info = "creating random events"
                        for _ in 1...(Int(numberOfEvents) ?? 1) {
                            try await viewModel.createEvent(isForFuture: isForFuture)
                        }
                        info = "successfully created \(numberOfEvents) random events"
                    } catch {
                        info = error.localizedDescription
                    }
                }
            } label: {
                Text("Generate \(numberOfEvents) Random Events")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 25)
            
            Spacer()
        }
        .background(Color(UIColor.systemGray6))
        .onAppear {
            Task { @MainActor in _ = await viewModel.requestAccess() }
        }
    }
    
}
