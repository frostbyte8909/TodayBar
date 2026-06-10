import Foundation
import AppKit

struct ImportManager {
    static func promptForImport() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["ics"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        // Ensure UI is presented on the main thread
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            if panel.runModal() == .OK, let url = panel.url {
                handleImport(fileURL: url)
            }
        }
    }
    
    static func handleImport(fileURL: URL) {
        let alert = NSAlert()
        alert.messageText = "Import Calendar"
        alert.informativeText = "How would you like to handle this calendar file? Storing as a read-only source is supported for webcal URLs. Local files will be opened in Apple Calendar natively."
        alert.addButton(withTitle: "Open in Apple Calendar")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        
        if response == .alertFirstButtonReturn {
            NSWorkspace.shared.open(fileURL)
        }
    }
}
