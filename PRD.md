# PRD: TodayBar — macOS Menu Bar Calendar

## Product overview
TodayBar is a native macOS menu bar extra that exposes a compact, highly readable, today-only agenda view for Calendar and Reminders data already present on the Mac via EventKit. The product deliberately mirrors Apple Calendar’s visual language, typography, color behavior, and interaction patterns as closely as possible while removing navigation chrome, reducing whitespace, and making the current day glanceable in one click.

The app is designed for macOS 14.0 (Sonoma) and newer. It is a portfolio-grade, public GitHub release intended to feel native rather than branded, novel, or stylized.

## Problem statement
Apple Calendar on macOS is powerful, but checking only today’s schedule often requires opening a full application surface with more spatial overhead, more navigation, and more whitespace than necessary for quick reference. Users who only want to see the current day’s events and reminders need a smaller, faster, menu bar-native view that preserves Apple’s familiarity while improving density and scan speed.

## Goals
- Provide a one-click, today-only schedule surface from the menu bar.
- Preserve Apple Calendar’s visual language as closely as possible in typography, color, spacing logic, and interaction tone.
- Show all enabled calendars through EventKit, plus reminders/tasks, in a single focused popover.
- Improve readability by reducing empty space and removing nonessential chrome without making the interface feel cramped or off-brand.
- Keep all detailed editing and event creation delegated to Apple Calendar rather than duplicating a full planner workflow.

## Non-goals
- No month view, week view, or full calendar navigation.
- No in-app event editing, natural-language event creation, or account management.
- No direct integration with Google Calendar, Outlook, or third-party providers beyond what the system already exposes through EventKit.
- No custom brand-heavy UI, no aggressive density, and no non-native motion language.

## Target user
The primary user is a macOS user who already relies on Apple Calendar and Reminders, wants fast access to the current day from the menu bar, and values a compact but native-feeling interface over feature breadth. The user is likely to check schedule state many times per day and prefers system-consistent tools that minimize context switching.

## Product principles
- **Today only.** Every screen and behavior should reinforce the product’s single purpose: fast access to today’s schedule.
- **Native first.** If a design choice conflicts with Apple platform conventions, the Apple-like option wins unless readability is materially improved by deviation.
- **Remove chrome, not clarity.** Density comes from deleting unnecessary structure, not shrinking text or compressing touch/click targets beyond comfort.
- **Defer depth.** Opening, editing, and creating events should hand off to Apple Calendar.
- **System-aware surfaces.** Material, border, and contrast behavior should adapt to menu bar appearance and macOS accessibility settings.

## Core experience
The app lives in the menu bar as an icon-only extra. It runs as an agent app (`LSUIElement = YES`) so there is no Dock icon or Cmd+Tab presence. 
- A **primary (left) click** opens a popover showing only today’s information, ordered as all-day event chips/rows, timed calendar events, and reminders.
- Clicking an event opens the corresponding item in Apple Calendar.
- A **secondary (right) click** exposes a minimal context menu with copy, settings, open/create in Calendar, repository, delete/reset, and quit actions.

If today has no events but has reminders, reminders become the main content block. If both events and reminders are absent, the interface shows a quiet empty state reading “No events today.”

## Information architecture
Popover content order:
1. Header strip
2. All-day events section
3. Timed events section
4. Separator
5. Reminders section
6. Footer utility strip (optional, low-emphasis)

### Header strip
The header is intentionally minimal and should not imitate a window toolbar. It contains only the current day label and optional secondary metadata; no mini-month, no navigation arrows, and no date picker are present.
- Left: “Today” label
- Right: full localized date, e.g. “Wed, 10 Jun”

### All-day events
All-day events dynamically adjust layout based on count:
- **0–2 events:** Stack vertically as full-width rows, sharing equal height. They use calendar color outlines without a time column.
- **3+ events:** Switch to a single horizontal row with scrolling chips. If the row exceeds popover width, a "+N more" overflow chip is used.

### Timed events
Timed events appear as a chronological vertical list using compact rounded blocks with subtle outline treatment indicating calendar color. Each row includes only time, title, and calendar color identity.

### Separator
A static visual divider line (1px hairline) is always present between the events and reminders sections. It uses the separator color at ~45% opacity in light mode and ~55% in dark mode.

### Reminders
Reminders appear in a separate section below the separator. Reminders without due times remain in the same section at the bottom, hard-capped to a maximum of 10 visible items to prevent overwhelming vertical scroll.

## Visual design specification

### Platform alignment
Visually align with Apple Calendar on macOS, matching SF Pro, system colors, and native materials.

### Typography
- Font family: SF Pro Text / SF Pro Display
- Header primary label: 13 pt, semibold
- Header secondary date: 12 pt, regular
- Section labels: 11 pt, medium, secondary color
- Event time: 12 pt, medium, monospaced numerals
- Event title: 13 pt, regular or medium
- Reminder title: 13 pt, regular
- Chip text: 11 pt, medium
- Empty state text: 13 pt, regular
- Text colors: Standard system label colors.

### Materials and frosting
Use native macOS material APIs.
- Light mode: ultra-thin material equivalent.
- Dark mode: ultra-thin to thin material equivalent.

### Color system
- Base colors: system material background, labelColor, secondaryLabelColor, separatorColor (65%).
- Event outline: source calendar color at 85% (dark) / 78% (light) opacity.
- Event fill: source calendar color tinted at 6% (light) / 9% (dark) fill.
- Chip fill: 12% fill over system background.

### Borders, Corner Radii, Spacing
- Popover radius: 14 px
- Event row radius: 10 px
- All-day chip radius: 9 px
- Base spacing unit: 4 px.
- Popover horizontal padding: 12 px

### Layout specification
- **Menu bar icon:** SF Symbol-style calendar glyph.
- **Popover dimensions:** Default width 336 px, dynamically hugs content height up to 50vh max.
- **Header:** 34 px total height.
- **Event row:** Standard height 46 px, compact blocks.
- **Reminder row:** Standard height 32 px.

## Interaction specification
- **Left click:** Opens the popover.
- **Right click:** Opens a context menu (requires AppKit `NSStatusItem` under the hood).
- **Event row click:** Opens event in Apple Calendar.
- **Reminder row click:** Attempts to direct deep-link using `calendarItemExternalIdentifier`. If this fails or is unreliable, falls back to opening the main Apple Reminders app (`x-apple-reminder://`).
- **Hover:** Subtle system-like hover states (+3% to 4% tinted fill).
- **Scroll:** Native scrolling for internal content region.

## Settings window specification
Lightweight SwiftUI window with standard macOS tabs:
- General
- Appearance
- Calendars
- Reminders (Includes toggle for undated reminders, capped at 10)
- Permissions
- About

## Engineering notes
- **Minimum Target:** macOS 14.0 (Sonoma).
- **Stack:** Swift + AppKit `NSStatusItem` for the menu bar hook (to support true left-click popover / right-click menu split), with SwiftUI used for the popover content, settings window, and all main views. EventKit for data.
- **App Visibility:** Runs as an agent (`LSUIElement = YES`) with no dock icon or window switcher presence.
- **Popover Sizing:** Height is fully dynamic, bounded by `NSScreen.main?.frame.height * 0.5`.
