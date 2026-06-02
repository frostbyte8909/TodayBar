import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var eventKitManager = EventKitManager()
    
    // To handle clicks before the default menu pops up, we need a custom NSView or NSEvent monitoring.
    // The cleanest way is using a custom NSButton inside the status item.
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 1. Create the Popover
        popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: AgendaView().environmentObject(eventKitManager)
        )
        
        // 2. Setup the Status Item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "TodayBar")
            button.action = #selector(handleStatusItemClick(_:))
            button.target = self
            // Enable right-click (secondary click)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    @objc func handleStatusItemClick(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == .rightMouseUp {
            // Secondary (Right) Click -> Show Menu
            showContextMenu()
        } else {
            // Primary (Left) Click -> Toggle Popover
            togglePopover(sender)
        }
    }
    
    func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: Any?) {
        if let button = statusItem.button {
            // Refresh data right before showing
            eventKitManager.fetchData()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(_ sender: Any?) {
        popover.performClose(sender)
    }
    
    func showContextMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Open Calendar", action: #selector(openCalendar), keyEquivalent: "c"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit TodayBar", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        statusItem.button?.performClick(nil) // This will pop the menu immediately
        statusItem.menu = nil // Clear it so left-click works again next time
    }
    
    @objc func openSettings() {
        if #available(macOS 13.0, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func openCalendar() {
        if let url = URL(string: "ical://") {
            NSWorkspace.shared.open(url)
        }
    }
}
