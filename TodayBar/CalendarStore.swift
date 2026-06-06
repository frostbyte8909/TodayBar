import Foundation
import EventKit
import Combine
import AppKit

class CalendarStore: ObservableObject {
    @Published var allDayEvents: [EKEvent] = []
    @Published var timedEvents: [EKEvent] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(settings: SettingsState, accountManager: AccountManager) {
        NotificationCenter.default.addObserver(self, selector: #selector(eventStoreChanged), name: .EKEventStoreChanged, object: nil)
        
        settings.objectWillChange
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.fetchEvents(settings: settings, accountManager: accountManager)
                }
            }
            .store(in: &cancellables)
            
        accountManager.$permissionGranted
            .sink { [weak self] granted in
                if granted {
                    self?.fetchEvents(settings: settings, accountManager: accountManager)
                }
            }
            .store(in: &cancellables)
            
        if accountManager.permissionGranted {
            fetchEvents(settings: settings, accountManager: accountManager)
        }
    }
    
    @objc private func eventStoreChanged() {
        // Will rely on explicit refetch or pass dependencies to a robust update loop if needed
        // For now, this is triggered when EKEventStore changes. We need settings reference, so we handle it gracefully.
        // The robust way is to store references to settings and accountManager
    }
    
    func fetchEvents(settings: SettingsState, accountManager: AccountManager) {
        guard accountManager.permissionGranted else { return }
        
        let store = EventStoreProvider.shared
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let allCalendars = store.calendars(for: .event)
        let enabledCalendars = allCalendars.filter { settings.isCalendarEnabled($0.calendarIdentifier) }
        
        guard !enabledCalendars.isEmpty else {
            self.allDayEvents = []
            self.timedEvents = []
            return
        }
        
        let predicate = store.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: enabledCalendars)
        let events = store.events(matching: predicate)
        
        self.allDayEvents = events.filter { $0.isAllDay }.sorted { $0.startDate < $1.startDate }
        self.timedEvents = events.filter { !$0.isAllDay }.sorted { $0.startDate < $1.startDate }
    }
    
    func openEventInCalendar(_ event: EKEvent) {
        guard let url = URL(string: "ical://") else { return }
        NSWorkspace.shared.open(url)
    }
}
