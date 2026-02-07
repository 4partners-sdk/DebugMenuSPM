import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func errorAlert(error: Binding<Error?>) -> some View {
        self.alert(
            "Error",
            isPresented: Binding<Bool>(
                get: { error.wrappedValue != nil },
                set: { newValue in
                    if !newValue { error.wrappedValue = nil } // reset error when alert dismissed
                }
            ),
            presenting: error.wrappedValue
        ) { _ in
            Button("OK", role: .cancel) { }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
}
