import SwiftUI
import EventKit

struct AllDayChip: View {
    let event: EKEvent
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Text(event.title ?? "All Day")
            .font(Theme.Typography.chipText)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .frame(height: Theme.Layout.chipHeight)
            .background(
                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusChip)
                    .fill(Theme.Colors.chipFill().opacity(isHovered ? 1.3 : 1.0))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusChip)
                    .stroke(Theme.Colors.eventOutline(color: event.calendar.cgColor, isDark: colorScheme == .dark), lineWidth: 1)
            )
            .onHover { hovering in
                withAnimation(.easeOut(duration: 0.12)) {
                    isHovered = hovering
                }
            }
    }
}
