import SwiftUI
import EventKit

struct SettingsView: View {
    @EnvironmentObject var settingsState: SettingsState
    @EnvironmentObject var accountManager: AccountManager
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem { Label("General", systemImage: "gear") }
            CalendarsSettingsView()
                .tabItem { Label("Accounts", systemImage: "person.2.crop.square.stack") }
            RemindersSettingsView()
                .tabItem { Label("Reminders", systemImage: "list.bullet") }
            AboutSettingsView()
                .tabItem { Label("About", systemImage: "info.circle") }
        }
        .padding(20)
        .frame(width: 480, height: 420)
    }
}

struct GeneralSettingsView: View {
    @EnvironmentObject var settingsState: SettingsState
    
    var body: some View {
        Form {
            if #available(macOS 13.0, *) {
                Toggle("Launch at Login", isOn: $settingsState.launchAtLogin)
            }
            
            Button("Quit TodayBar") {
                NSApplication.shared.terminate(nil)
            }
            .padding(.top, 20)
        }
        .padding()
    }
}

struct CalendarsSettingsView: View {
    @EnvironmentObject var accountManager: AccountManager
    @EnvironmentObject var settingsState: SettingsState
    
    var body: some View {
        if !accountManager.permissionGranted {
            VStack {
                Text("Calendar permissions not granted.")
                    .foregroundColor(.secondary)
            }
        } else if accountManager.sources.isEmpty {
            VStack {
                Text("No calendar accounts found.")
                    .foregroundColor(.secondary)
            }
        } else {
            List {
                ForEach(accountManager.sources, id: \.sourceIdentifier) { source in
                    let calendars = accountManager.eventCalendars(for: source)
                    if !calendars.isEmpty {
                        Section(header: Text(source.title).font(.headline).padding(.top, 4)) {
                            ForEach(calendars, id: \.calendarIdentifier) { calendar in
                                Toggle(isOn: Binding(
                                    get: { settingsState.isCalendarEnabled(calendar.calendarIdentifier) },
                                    set: { enabled in settingsState.toggleCalendar(calendar.calendarIdentifier, isEnabled: enabled) }
                                )) {
                                    HStack {
                                        Circle()
                                            .fill(Color(nsColor: calendar.color))
                                            .frame(width: 10, height: 10)
                                        Text(calendar.title)
                                    }
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            }
                        }
                        Divider()
                    }
                }
            }
            .listStyle(SidebarListStyle())
        }
    }
}

struct RemindersSettingsView: View {
    @EnvironmentObject var settingsState: SettingsState
    @EnvironmentObject var accountManager: AccountManager
    
    var body: some View {
        Form {
            Toggle("Show Undated Reminders", isOn: $settingsState.showUndatedReminders)
            Text("Capped at 10 items to prevent popover overflow.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct AboutSettingsView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(systemName: "calendar")
                .font(.system(size: 40))
                .padding(.bottom, 10)
            
            Text("TodayBar")
                .font(.headline)
            Text("Version 1.1")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Link("View on GitHub", destination: URL(string: "https://github.com/frostbyte8909/TodayBar")!)
                .padding(.top, 10)
            
            Spacer()
        }
    }
}
