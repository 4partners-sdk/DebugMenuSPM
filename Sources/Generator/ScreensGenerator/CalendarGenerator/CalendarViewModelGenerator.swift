import SwiftUI

final class CalendarViewModelGenerator: ObservableObject {
    
    private let calendarService: CalendarServiceGenerator = CalendarServiceImpl()
    
    public func requestAccess() async -> Bool {
        await calendarService.requestAccess()
    }
    
    public func createEvent(isForFuture: Bool) async throws {
        let title = CalendarModelGenerator.titles.randomElement() ?? "Untitled Event"
        
        let filteredDates = CalendarModelGenerator.startDates.filter {
            isForFuture ? $0 > Date() : $0 < Date()
        }
        
        let startDate = filteredDates.randomElement() ?? Date()
        
        let timeInterval = CalendarModelGenerator.timeIntervals.randomElement() ?? 3600
        let endDate = startDate.addingTimeInterval(timeInterval)
        
        try await calendarService.createEvent(
            title: title,
            startDate: startDate,
            endDate: endDate
        )
    }
    
}
