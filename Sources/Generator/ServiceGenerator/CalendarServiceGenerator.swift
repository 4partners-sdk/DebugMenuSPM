import UIKit
import EventKit

protocol CalendarServiceGenerator {
    func requestAccess() async -> Bool
    
    func createEvent(
        title: String,
        startDate: Date,
        endDate: Date
    ) async throws
}

final class CalendarServiceImpl: CalendarServiceGenerator {
    private let calendarStore = EKEventStore()
}

extension CalendarServiceImpl {
    public func createEvent(
        title: String,
        startDate: Date,
        endDate: Date
    ) async throws {
        let event = EKEvent(eventStore: calendarStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "default notes"
        event.location = "default location"
        event.calendar = calendarStore.defaultCalendarForNewEvents
        
        try calendarStore.save(event, span: .thisEvent)
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
