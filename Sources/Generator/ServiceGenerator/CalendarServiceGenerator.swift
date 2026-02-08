import UIKit
import Combine
import EventKit

typealias EventEntity = EKEvent

protocol CalendarServiceGenerator {
    var allEventsPublisher: AnyPublisher<[EventEntity], Never> { get }
    
    func requestAccess() async -> Bool
    func fetchAll() async throws
    func deleteAll() async throws
    
    func createEvents(
        numberOfEvents: Int,
        startDate: Date,
        endDate: Date
    ) async throws
}

final class CalendarServiceImpl: CalendarServiceGenerator {
    private let calendarStore = EKEventStore()
    
    @Published private var allEvents: [EventEntity] = []
    public var allEventsPublisher: AnyPublisher<[EventEntity], Never> {
        $allEvents.eraseToAnyPublisher()
    }
}

extension CalendarServiceImpl {
    public func fetchAll() async throws {
        let startDate: Date = Date(timeIntervalSince1970: NSTimeIntervalSince1970)
        let stopDate: Date = Date(timeIntervalSinceNow: 24 * 3600 * 36500) // +100 years
        
        var collectedEvents: [EventEntity] = []
        
        var currentStopDate = stopDate
        while currentStopDate > startDate {
            let currentStartDate = Calendar.current.date(
                byAdding: .year,
                value: -1,
                to: currentStopDate
            ) ?? startDate
            
            let predicate = calendarStore.predicateForEvents(
                withStart: currentStartDate,
                end: currentStopDate,
                calendars: nil
            )
            
            let events = calendarStore.events(matching: predicate)
            let filteredEvents = events.filter { !$0.calendar.isImmutable }
            
            collectedEvents.append(contentsOf: filteredEvents)
            currentStopDate = currentStartDate
        }
        
        // Replace the published array instead of appending
        allEvents = collectedEvents
    }
    
    public func createEvents(
        numberOfEvents: Int,
        startDate: Date,
        endDate: Date
    ) async throws {
        let safeStartDate = min(startDate, endDate)
        let safeEndDate = max(startDate, endDate)
        
        try await Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            
            for _ in 0..<numberOfEvents {
                // Dynamic title
                let title = "\(CalendarModelGenerator.titles.randomElement() ?? "Event") - \(Int.random(in: 0...1000))"
                
                // Random start and end
                let startInterval = TimeInterval.random(in: 0..<safeEndDate.timeIntervalSince(safeStartDate))
                let randomEventStart = safeStartDate.addingTimeInterval(startInterval)
                
                let remainingTime = safeEndDate.timeIntervalSince(randomEventStart)
                let duration = TimeInterval.random(in: 60...max(60, remainingTime))
                let randomEventEnd = randomEventStart.addingTimeInterval(duration)
                
                // Create the event
                let event = EKEvent(eventStore: calendarStore)
                event.title = title
                event.startDate = randomEventStart
                event.endDate = randomEventEnd
                event.notes = "default notes"
                event.location = "default location"
                event.calendar = calendarStore.defaultCalendarForNewEvents
                
                // Save event without committing
                try calendarStore.save(event, span: .thisEvent, commit: false)
            }
            
            // Commit all events at once
            try calendarStore.commit()
        }.value // wait for completion
        
        try await fetchAll()
    }
    
    public func deleteAll() async throws {
        try allEvents.forEach { event in
            try calendarStore.remove(
                event,
                span: .thisEvent,
                commit: false
            )
        }
        try calendarStore.commit()
        allEvents = []
    }
}

extension CalendarServiceImpl {
    public func requestAccess() async -> Bool {
        let  authorizationStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch authorizationStatus {
        case .authorized, .fullAccess: return true
        case .restricted, .denied, .writeOnly: openSettings(); return false
        case .notDetermined:
            if #available(iOS 17.0, *) {
                do {
                    let accessGranted = try await calendarStore.requestFullAccessToEvents()
                    return accessGranted
                } catch {
                    return false
                }
            } else {
                do {
                    let accessGranted = try await calendarStore.requestAccess(to: .event)
                    return accessGranted
                } catch {
                    return false
                }
            }
        @unknown default: return false
        }
    }
    
    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}
