import SwiftUI
import AppKit

@main
struct TodayBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // We do not use MenuBarExtra here because we need dual left-click/right-click behavior
        // managed by AppKit's NSStatusItem in the AppDelegate.
        // Instead, we just provide the Settings window scene.
        Settings {
            SettingsView()
        }
    }
}
