import SwiftUI
import EventKit

struct EventRow: View {
    let event: EKEvent
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Time Column
            Text(timeString(from: event.startDate))
                .font(Theme.Typography.eventTime)
                .foregroundColor(.primary)
                .frame(width: Theme.Layout.timeColumnWidth, alignment: .leading)
                .padding(.leading, Theme.Spacing.compact)
            
            // Title Column
            Text(event.title ?? "New Event")
                .font(Theme.Typography.eventTitle)
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer(minLength: Theme.Spacing.compact)
        }
        .frame(height: Theme.Layout.eventRowHeight)
        .background(
            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusEventRow)
                .fill(Theme.Colors.eventFill(color: event.calendar.cgColor, isDark: colorScheme == .dark).opacity(isHovered ? 1.3 : 1.0))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusEventRow)
                .stroke(Theme.Colors.eventOutline(color: event.calendar.cgColor, isDark: colorScheme == .dark).opacity(isHovered ? 1.1 : 1.0), lineWidth: 1)
        )
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.12)) {
                isHovered = hovering
            }
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
