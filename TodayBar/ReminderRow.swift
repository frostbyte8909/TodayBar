import SwiftUI
import EventKit

struct ReminderRow: View {
    let reminder: EKReminder
    @EnvironmentObject var reminderStore: ReminderStore
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: Theme.Spacing.compact) {
            Button(action: {
                reminderStore.toggleCompletion(for: reminder)
            }) {
                Image(systemName: reminder.isCompleted ? "circle.inset.filled" : "circle")
                    .foregroundColor(reminder.isCompleted ? .secondary : Color(cgColor: reminder.calendar.cgColor))
                    .font(.system(size: 14))
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, Theme.Spacing.compact)
            
            Text(reminder.title ?? "Reminder")
                .font(Theme.Typography.reminderTitle)
                .foregroundColor(reminder.isCompleted ? .secondary : .primary)
                .lineLimit(1)
            
            Spacer()
        }
        .frame(height: Theme.Layout.reminderRowHeight)
        .background(
            RoundedRectangle(cornerRadius: Theme.Spacing.compact)
                .fill(Color.primary.opacity(isHovered ? 0.05 : 0.0))
        )
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.12)) {
                isHovered = hovering
            }
        }
    }
}
