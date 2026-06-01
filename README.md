# TodayBar

A native macOS menu bar calendar utility focused exclusively on today's events and reminders.

## Features
- **Today Only**: Fast, one-click access to today's schedule.
- **Native UI**: Built with AppKit and SwiftUI to match macOS Sonoma/Sequoia system typography, colors, and materials.
- **Dual Menu Bar Behavior**: Left-click to view the agenda popover; Right-click to access quick utility actions.
- **EventKit Driven**: Uses your existing Calendar and Reminders data securely without third-party integrations.

## Building the Project

### Requirements
- Xcode 15+ 
- macOS 14.0+ (Sonoma or newer)
- [xcodegen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)

### Steps
1. Clone the repository.
2. Run `xcodegen generate` in the root folder to generate the `TodayBar.xcodeproj` file.
3. Open `TodayBar.xcodeproj` in Xcode.
4. Build and Run.

## Privacy & Permissions
Because the app accesses your Calendar and Reminders via EventKit, macOS will prompt you for permission upon first launch. 
If you accidentally denied permission, you can grant it manually:
1. Open **System Settings** > **Privacy & Security**.
2. Go to **Calendars** and allow TodayBar.
3. Go to **Reminders** and allow TodayBar.

Since this initial release does not use the App Sandbox, there is no additional entitlement friction for local builds.
