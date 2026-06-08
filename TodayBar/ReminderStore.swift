import Foundation
import EventKit
import Combine
import AppKit

class ReminderStore: ObservableObject {
    @Published var reminders: [EKReminder] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var settings: SettingsState?
    private var accountManager: AccountManager?
    
    init(settings: SettingsState, accountManager: AccountManager) {
        self.settings = settings
        self.accountManager = accountManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(eventStoreChanged), name: .EKEventStoreChanged, object: nil)
        
        settings.objectWillChange
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.fetchReminders()
                }
            }
            .store(in: &cancellables)
            
        accountManager.$permissionGranted
            .sink { [weak self] granted in
                if granted {
                    self?.fetchReminders()
                }
            }
            .store(in: &cancellables)
            
        if accountManager.permissionGranted {
            fetchReminders()
        }
    }
    
    @objc private func eventStoreChanged() {
        DispatchQueue.main.async {
            self.fetchReminders()
        }
    }
    
    func fetchReminders() {
        guard let accountManager = accountManager, let settings = settings, accountManager.permissionGranted else { return }
        
        let store = EventStoreProvider.shared
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let allCalendars = store.calendars(for: .reminder)
        let enabledCalendars = allCalendars.filter { settings.isCalendarEnabled($0.calendarIdentifier) }
        
        guard !enabledCalendars.isEmpty else {
            self.reminders = []
            return
        }
        
        let predicate = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: endOfDay, calendars: enabledCalendars)
        store.fetchReminders(matching: predicate) { [weak self] fetchedReminders in
            DispatchQueue.main.async {
                let allReminders = fetchedReminders ?? []
                let todayReminders = allReminders.filter { reminder in
                    if let dueDate = reminder.dueDateComponents?.date {
                        return calendar.isDate(dueDate, inSameDayAs: Date()) || dueDate < startOfDay
                    }
                    return false
                }
                
                var finalReminders = todayReminders
                
                if settings.showUndatedReminders {
                    let undatedReminders = allReminders.filter { $0.dueDateComponents == nil }
                    let cappedUndated = Array(undatedReminders.prefix(10))
                    finalReminders += cappedUndated
                }
                
                self?.reminders = finalReminders
            }
        }
    }
    
    func openReminderInApp(_ reminder: EKReminder) {
        guard let url = URL(string: "x-apple-reminder://") else { return }
        NSWorkspace.shared.open(url)
    }
    
    func toggleCompletion(for reminder: EKReminder) {
        let store = EventStoreProvider.shared
        reminder.isCompleted = !reminder.isCompleted
        
        do {
            try store.save(reminder, commit: true)
        } catch {
            print("Failed to save reminder: \(error)")
        }
    }
}
