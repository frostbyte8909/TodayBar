import Foundation
import EventKit
import SwiftUI

class EventKitManager: ObservableObject {
    let store = EKEventStore()
    
    @Published var permissionGranted = false
    @Published var allDayEvents: [EKEvent] = []
    @Published var timedEvents: [EKEvent] = []
    @Published var reminders: [EKReminder] = []
    
    init() {
        checkPermissions()
        NotificationCenter.default.addObserver(self, selector: #selector(eventStoreChanged), name: .EKEventStoreChanged, object: nil)
    }
    
    @objc func eventStoreChanged() {
        DispatchQueue.main.async {
            self.fetchData()
        }
    }
    
    func checkPermissions() {
        let calendarStatus = EKEventStore.authorizationStatus(for: .event)
        let reminderStatus = EKEventStore.authorizationStatus(for: .reminder)
        
        if calendarStatus == .authorized && reminderStatus == .authorized {
            self.permissionGranted = true
            self.fetchData()
        } else {
            // macOS 14 introduced new ways, but requestAccess is still commonly used with completion block
            if #available(macOS 14.0, *) {
                Task {
                    do {
                        let calGranted = try await store.requestFullAccessToEvents()
                        let remGranted = try await store.requestFullAccessToReminders()
                        DispatchQueue.main.async {
                            self.permissionGranted = calGranted && remGranted
                            if self.permissionGranted {
                                self.fetchData()
                            }
                        }
                    } catch {
                        print("Permission error: \(error)")
                    }
                }
            } else {
                // Fallback for earlier versions
                store.requestAccess(to: .event) { calGranted, _ in
                    self.store.requestAccess(to: .reminder) { remGranted, _ in
                        DispatchQueue.main.async {
                            self.permissionGranted = calGranted && remGranted
                            if self.permissionGranted {
                                self.fetchData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchData() {
        guard permissionGranted else { return }
        
        // 1. Fetch Events for Today
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = store.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: nil)
        let events = store.events(matching: predicate)
        
        self.allDayEvents = events.filter { $0.isAllDay }.sorted { $0.startDate < $1.startDate }
        self.timedEvents = events.filter { !$0.isAllDay }.sorted { $0.startDate < $1.startDate }
        
        // 2. Fetch Reminders
        let remindersPredicate = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: endOfDay, calendars: nil)
        store.fetchReminders(matching: remindersPredicate) { fetchedReminders in
            DispatchQueue.main.async {
                let allReminders = fetchedReminders ?? []
                // We want: Reminders due today OR undated reminders (capped at 10)
                let todayReminders = allReminders.filter { reminder in
                    if let dueDate = reminder.dueDateComponents?.date {
                        return calendar.isDate(dueDate, inSameDayAs: Date()) || dueDate < startOfDay
                    }
                    return false
                }
                
                let undatedReminders = allReminders.filter { $0.dueDateComponents == nil }
                
                // Cap undated reminders at 10
                let cappedUndated = Array(undatedReminders.prefix(10))
                
                self.reminders = todayReminders + cappedUndated
            }
        }
    }
    
    func openEventInCalendar(_ event: EKEvent) {
        // macOS provides a scheme to open an event if we have its external identifier
        guard let url = URL(string: "ical://") else { return }
        NSWorkspace.shared.open(url)
        // Note: For deep-linking to a specific event, there are private methods, but 
        // standard URL schemes in modern macOS generally just open the app to today.
    }
    
    func openReminderInApp(_ reminder: EKReminder) {
        guard let url = URL(string: "x-apple-reminder://") else { return }
        NSWorkspace.shared.open(url)
    }
}
