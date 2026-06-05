import SwiftUI
import ServiceManagement

class SettingsState: ObservableObject {
    @AppStorage("showUndatedReminders") var showUndatedReminders: Bool = true
    @AppStorage("disabledCalendarIDs") private var disabledCalendarIDsString: String = ""
    
    // Safely encode/decode calendar identifiers
    var disabledCalendarIDs: Set<String> {
        get {
            let ids = disabledCalendarIDsString.split(separator: ",").map(String.init)
            return Set(ids)
        }
        set {
            disabledCalendarIDsString = newValue.joined(separator: ",")
            self.objectWillChange.send()
        }
    }
    
    @Published var launchAtLogin: Bool = false {
        didSet {
            toggleLaunchAtLogin(launchAtLogin)
        }
    }
    
    init() {
        if #available(macOS 13.0, *) {
            self.launchAtLogin = SMAppService.mainApp.status == .enabled
        }
    }
    
    private func toggleLaunchAtLogin(_ enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to update launch at login status: \(error)")
            }
        }
    }
    
    func isCalendarEnabled(_ identifier: String) -> Bool {
        return !disabledCalendarIDs.contains(identifier)
    }
    
    func toggleCalendar(_ identifier: String, isEnabled: Bool) {
        var current = disabledCalendarIDs
        if isEnabled {
            current.remove(identifier)
        } else {
            current.insert(identifier)
        }
        disabledCalendarIDs = current
    }
}
