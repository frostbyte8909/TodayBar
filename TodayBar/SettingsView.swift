import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            AppearanceSettingsView()
                .tabItem {
                    Label("Appearance", systemImage: "macwindow")
                }
            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .padding(20)
        .frame(width: 400, height: 250)
    }
}

struct GeneralSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("TodayBar Settings")
                .font(.headline)
            
            Button("Quit TodayBar") {
                NSApplication.shared.terminate(nil)
            }
            Spacer()
        }
    }
}

struct AppearanceSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Appearance")
                .font(.headline)
            Text("TodayBar automatically follows your system's light or dark mode setting.")
                .foregroundColor(.secondary)
            Spacer()
        }
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
            Text("Version 1.0")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Link("View on GitHub", destination: URL(string: "https://github.com/example/todaybar")!)
                .padding(.top, 10)
            
            Spacer()
        }
    }
}
