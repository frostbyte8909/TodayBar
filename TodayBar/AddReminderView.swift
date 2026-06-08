import SwiftUI
import EventKit

struct AddReminderView: View {
    @EnvironmentObject var reminderStore: ReminderStore
    @EnvironmentObject var accountManager: AccountManager
    @State private var text: String = ""
    
    var body: some View {
        HStack(spacing: Theme.Spacing.compact) {
            Image(systemName: "plus.circle")
                .foregroundColor(.secondary)
                .font(.system(size: 14))
                .padding(.leading, Theme.Spacing.compact)
            
            TextField("New Reminder", text: $text, onCommit: {
                if !text.isEmpty {
                    addReminder()
                }
            })
            .textFieldStyle(PlainTextFieldStyle())
            .font(Theme.Typography.reminderTitle)
            
            Spacer()
        }
        .frame(height: Theme.Layout.reminderRowHeight)
        .padding(.trailing, Theme.Spacing.standard)
    }
    
    func addReminder() {
        let store = EventStoreProvider.shared
        guard let defaultList = store.defaultCalendarForNewReminders() else { return }
        
        let reminder = EKReminder(eventStore: store)
        reminder.title = text
        reminder.calendar = defaultList
        
        do {
            try store.save(reminder, commit: true)
            text = ""
        } catch {
            print("Error creating reminder: \(error)")
        }
    }
}
