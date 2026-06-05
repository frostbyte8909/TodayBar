import Foundation
import EventKit
import Combine

class AccountManager: ObservableObject {
    @Published var permissionGranted = false
    @Published var sources: [EKSource] = []
    
    init() {
        checkPermissions()
    }
    
    func checkPermissions() {
        let store = EventStoreProvider.shared
        let calendarStatus = EKEventStore.authorizationStatus(for: .event)
        let reminderStatus = EKEventStore.authorizationStatus(for: .reminder)
        
        if calendarStatus == .authorized && reminderStatus == .authorized {
            self.permissionGranted = true
            self.fetchSources()
        } else {
            if #available(macOS 14.0, *) {
                Task {
                    do {
                        let calGranted = try await store.requestFullAccessToEvents()
                        let remGranted = try await store.requestFullAccessToReminders()
                        DispatchQueue.main.async {
                            self.permissionGranted = calGranted && remGranted
                            if self.permissionGranted {
                                self.fetchSources()
                            }
                        }
                    } catch {
                        print("Permission error: \(error)")
                    }
                }
            } else {
                store.requestAccess(to: .event) { calGranted, _ in
                    store.requestAccess(to: .reminder) { remGranted, _ in
                        DispatchQueue.main.async {
                            self.permissionGranted = calGranted && remGranted
                            if self.permissionGranted {
                                self.fetchSources()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchSources() {
        guard permissionGranted else { return }
        let store = EventStoreProvider.shared
        
        let allSources = store.sources.filter { source in
            !source.calendars(for: .event).isEmpty || !source.calendars(for: .reminder).isEmpty
        }
        
        self.sources = allSources.sorted { $0.title < $1.title }
    }
    
    func eventCalendars(for source: EKSource) -> [EKCalendar] {
        return source.calendars(for: .event).sorted { $0.title < $1.title }
    }
    
    func reminderCalendars(for source: EKSource) -> [EKCalendar] {
        return source.calendars(for: .reminder).sorted { $0.title < $1.title }
    }
}
