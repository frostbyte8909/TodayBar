import SwiftUI
import EventKit

struct QuickAddView: View {
    @EnvironmentObject var calendarStore: CalendarStore
    @State private var text: String = ""
    @State private var showingError = false
    
    var body: some View {
        HStack {
            TextField("E.g. Lunch with Sarah tomorrow at 1pm", text: $text, onCommit: {
                if !text.isEmpty {
                    addEvent()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if showingError {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
                    .help("Could not parse date from input")
            }
        }
        .padding(.horizontal, Theme.Layout.popoverPadding)
        .padding(.vertical, 8)
        .background(Theme.Colors.separator.opacity(0.1))
    }
    
    func addEvent() {
        guard let result = QuickAddParser.parse(text) else {
            showingError = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showingError = false
            }
            return
        }
        
        let store = EventStoreProvider.shared
        guard let defaultCalendar = store.defaultCalendarForNewEvents else { return }
        
        let event = EKEvent(eventStore: store)
        event.title = result.title
        event.startDate = result.date
        event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: result.date)!
        event.calendar = defaultCalendar
        
        do {
            try store.save(event, span: .thisEvent, commit: true)
            text = ""
            showingError = false
        } catch {
            print("Failed to save event: \(error)")
        }
    }
}
