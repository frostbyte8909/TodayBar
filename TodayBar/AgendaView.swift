import SwiftUI
import EventKit

struct AgendaView: View {
    @EnvironmentObject var eventKitManager: EventKitManager
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .padding(.horizontal, Theme.Layout.popoverPadding)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            if !eventKitManager.permissionGranted {
                PermissionStateView()
            } else if eventKitManager.allDayEvents.isEmpty && eventKitManager.timedEvents.isEmpty && eventKitManager.reminders.isEmpty {
                EmptyStateView()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.section) {
                        
                        // All Day Events
                        if !eventKitManager.allDayEvents.isEmpty {
                            if eventKitManager.allDayEvents.count <= 2 {
                                VStack(spacing: Theme.Spacing.compact) {
                                    ForEach(eventKitManager.allDayEvents, id: \.eventIdentifier) { event in
                                        Button(action: { eventKitManager.openEventInCalendar(event) }) {
                                            AllDayRow(event: event)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            } else {
                                AllDayChipsView(events: eventKitManager.allDayEvents)
                            }
                        }
                        
                        // Timed Events
                        if !eventKitManager.timedEvents.isEmpty {
                            VStack(spacing: Theme.Spacing.compact) {
                                ForEach(eventKitManager.timedEvents, id: \.eventIdentifier) { event in
                                    Button(action: { eventKitManager.openEventInCalendar(event) }) {
                                        EventRow(event: event)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        Divider()
                            .background(Theme.Colors.separator)
                            .padding(.vertical, 4)
                        
                        // Reminders
                        if !eventKitManager.reminders.isEmpty {
                            VStack(alignment: .leading, spacing: Theme.Spacing.micro) {
                                Text("Reminders")
                                    .font(Theme.Typography.sectionLabel)
                                    .foregroundColor(Theme.Colors.separator)
                                    .padding(.bottom, 2)
                                
                                ForEach(eventKitManager.reminders, id: \.calendarItemIdentifier) { reminder in
                                    Button(action: { eventKitManager.openReminderInApp(reminder) }) {
                                        ReminderRow(reminder: reminder)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Layout.popoverPadding)
                    .padding(.bottom, 12)
                }
            }
        }
        .frame(width: Theme.Layout.defaultWidth)
        .frame(maxHeight: (NSScreen.main?.visibleFrame.height ?? 1000) * 0.5)
        // Note: NSPopover handles the ultra-thin material background natively in AppKit.
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Today")
                .font(Theme.Typography.headerPrimary)
            Spacer()
            Text(formattedDate())
                .font(Theme.Typography.headerSecondary)
                .foregroundColor(.secondary)
        }
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        return formatter.string(from: Date())
    }
}

struct AllDayChipsView: View {
    let events: [EKEvent]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(events, id: \.eventIdentifier) { event in
                    Button(action: {
                        if let url = URL(string: "ical://") { NSWorkspace.shared.open(url) }
                    }) {
                        AllDayChip(event: event)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .frame(height: Theme.Layout.chipHeight)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Text("No events today")
                .font(Theme.Typography.emptyState)
                .foregroundColor(.secondary)
                .padding(.top, 20)
                .padding(.bottom, 16)
        }
    }
}

struct PermissionStateView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.standard) {
            Text("Permissions Required")
                .font(Theme.Typography.headerPrimary)
            Text("Please allow Calendar and Reminders access in System Settings > Privacy & Security.")
                .font(Theme.Typography.emptyState)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Button("Open System Settings") {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy") {
                    NSWorkspace.shared.open(url)
                }
            }
            .padding(.bottom, Theme.Spacing.large)
        }
        .padding(.horizontal, Theme.Layout.popoverPadding)
        .padding(.vertical, Theme.Spacing.large)
    }
}
