import SwiftUI
import Combine

@MainActor
final class CalendarViewModelGenerator: ObservableObject {
    private let calendarService: CalendarServiceGenerator = CalendarServiceImpl()
    
    @Published public var allEvents: [EventEntity] = []
    @Published public var state: CalendarActionState = .readyToGo
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        calendarService.allEventsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                self?.allEvents = events
            }
            .store(in: &cancellables)
        
        Task {
            isLoading = true; defer { isLoading = false }
            if await calendarService.requestAccess() {
                do {
                    try await calendarService.fetchAll()
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    public func createEvents(count: Int, startDate: Date, endDate: Date) {
        Task {
            isLoading = true; defer { isLoading = false }
            state = .creatingEvents(count: count)
            
            do {
                try await calendarService.createEvents(
                    numberOfEvents: count,
                    startDate: startDate,
                    endDate: endDate
                )
                state = .readyToGo
            } catch {
                self.error = error
            }
        }
    }
    
    public func deleteAll() {
        Task {
            isLoading = true; defer { isLoading = false }
            state = .deletingAllEvents
            
            do {
                try await calendarService.deleteAll()
                state = .readyToGo
            } catch {
                self.error = error
            }
        }
    }
}
