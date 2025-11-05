import SwiftUI

struct MainViewGenerator: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                NavigationLink(destination: ContactsView()) {
                    Text("Contacts")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: CalendarView()) {
                    Text("Calendar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: MediaView()) {
                    Text("Media")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}
