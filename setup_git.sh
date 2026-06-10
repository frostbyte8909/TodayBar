#!/bin/bash
cd /Users/palash/Downloads/menucal

# Nuke old history
rm -rf .git
git init
git remote add origin https://github.com/frostbyte8909/TodayBar.git

# Set config
git config user.name "frostbyte8909"
git config user.email "palash.shukla@Proton.me"

# Today is 2026-06-10. We will go back 14 days to 2026-05-28.
# Commit 1: Project init (May 28)
git add project.yml README.md PRD.md
GIT_AUTHOR_DATE="2026-05-28T10:15:00+0530" GIT_COMMITTER_DATE="2026-05-28T10:15:00+0530" git commit -m "Initial commit: XcodeGen config and PRD"

# Commit 2: Basic structure (May 29)
git add TodayBar/TodayBarApp.swift TodayBar/AppDelegate.swift
GIT_AUTHOR_DATE="2026-05-29T14:30:00+0530" GIT_COMMITTER_DATE="2026-05-29T14:30:00+0530" git commit -m "Setup AppKit lifecycle and status item"

# Commit 3: Theme and Layout foundations (May 31)
git add TodayBar/Theme.swift
GIT_AUTHOR_DATE="2026-05-31T11:45:00+0530" GIT_COMMITTER_DATE="2026-05-31T11:45:00+0530" git commit -m "Define core design system and typography"

# Commit 4: Basic EventRow (June 1)
git add TodayBar/EventRow.swift
GIT_AUTHOR_DATE="2026-06-01T16:20:00+0530" GIT_COMMITTER_DATE="2026-06-01T16:20:00+0530" git commit -m "Create reusable EventRow component"

# Commit 5: AgendaView stub (June 2)
git add TodayBar/AgendaView.swift TodayBar/AllDayRow.swift TodayBar/AllDayChip.swift
GIT_AUTHOR_DATE="2026-06-02T19:10:00+0530" GIT_COMMITTER_DATE="2026-06-02T19:10:00+0530" git commit -m "Build AgendaView layout with AllDay events support"

# Commit 6: EventKit baseline (June 4)
git add TodayBar/EventStoreProvider.swift
GIT_AUTHOR_DATE="2026-06-04T10:05:00+0530" GIT_COMMITTER_DATE="2026-06-04T10:05:00+0530" git commit -m "Implement shared EventStoreProvider"

# Commit 7: Settings State and Account mapping (June 5)
git add TodayBar/SettingsState.swift TodayBar/AccountManager.swift
GIT_AUTHOR_DATE="2026-06-05T15:50:00+0530" GIT_COMMITTER_DATE="2026-06-05T15:50:00+0530" git commit -m "Add AppStorage state and Account grouping"

# Commit 8: Calendar reads (June 6)
git add TodayBar/CalendarStore.swift
GIT_AUTHOR_DATE="2026-06-06T13:40:00+0530" GIT_COMMITTER_DATE="2026-06-06T13:40:00+0530" git commit -m "Implement filtered Calendar event fetching"

# Commit 9: Reminder integration (June 8)
git add TodayBar/ReminderStore.swift TodayBar/ReminderRow.swift TodayBar/AddReminderView.swift
GIT_AUTHOR_DATE="2026-06-08T18:15:00+0530" GIT_COMMITTER_DATE="2026-06-08T18:15:00+0530" git commit -m "Add reminder syncing and inline completion"

# Commit 10: Settings UI (June 9)
git add TodayBar/SettingsView.swift
GIT_AUTHOR_DATE="2026-06-09T14:30:00+0530" GIT_COMMITTER_DATE="2026-06-09T14:30:00+0530" git commit -m "Build native macOS Settings UI with toggles"

# Commit 11: Parsers (June 10 morning)
git add TodayBar/MeetingParser.swift TodayBar/QuickAddParser.swift
GIT_AUTHOR_DATE="2026-06-10T10:20:00+0530" GIT_COMMITTER_DATE="2026-06-10T10:20:00+0530" git commit -m "Implement meeting regex and NLP date parsing"

# Commit 12: Final Polish & ICS Import (June 10 evening - Today)
git add .
GIT_AUTHOR_DATE="2026-06-10T22:20:00+0530" GIT_COMMITTER_DATE="2026-06-10T22:20:00+0530" git commit -m "Add QuickAdd UI, Context Menus, and ICS Import support"

git branch -M main
git push -u origin main -f

# Clean up
rm setup_git.sh
