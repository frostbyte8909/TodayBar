import SwiftUI
import EventKit

struct EventRow: View {
    let event: EKEvent
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    
    var meetingLink: MeetingParser.MeetingLink? {
        MeetingParser.extractMeetingLink(from: event)
    }
    
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
            
            if let link = meetingLink {
                Button(action: {
                    NSWorkspace.shared.open(link.url)
                }) {
                    Image(systemName: link.platform.iconName)
                        .foregroundColor(.primary.opacity(0.8))
                        .font(.system(size: 14))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, Theme.Spacing.compact)
            }
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
        .contextMenu {
            Button("Copy Event Title") {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(event.title ?? "", forType: .string)
            }
            if let link = meetingLink {
                Button("Copy Meeting Link") {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(link.url.absoluteString, forType: .string)
                }
            }
            Button("Open in Calendar") {
                if let url = URL(string: "ical://") {
                    NSWorkspace.shared.open(url)
                }
            }
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
