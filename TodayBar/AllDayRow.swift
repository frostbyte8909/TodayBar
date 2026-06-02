import SwiftUI
import EventKit

struct AllDayRow: View {
    let event: EKEvent
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack {
            Text(event.title ?? "All Day Event")
                .font(Theme.Typography.eventTitle)
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, Theme.Spacing.standard)
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
}
