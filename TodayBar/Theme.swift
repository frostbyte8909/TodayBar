import SwiftUI

struct Theme {
    struct Typography {
        static let headerPrimary = Font.system(size: 13, weight: .semibold, design: .default)
        static let headerSecondary = Font.system(size: 12, weight: .regular, design: .default)
        static let sectionLabel = Font.system(size: 11, weight: .medium, design: .default)
        static let eventTime = Font.system(size: 12, weight: .medium, design: .monospaced)
        static let eventTitle = Font.system(size: 13, weight: .regular, design: .default)
        static let reminderTitle = Font.system(size: 13, weight: .regular, design: .default)
        static let chipText = Font.system(size: 11, weight: .medium, design: .default)
        static let emptyState = Font.system(size: 13, weight: .regular, design: .default)
    }
    
    struct Spacing {
        static let micro: CGFloat = 4
        static let compact: CGFloat = 8
        static let standard: CGFloat = 12
        static let section: CGFloat = 16
        static let large: CGFloat = 20
    }
    
    struct Layout {
        static let defaultWidth: CGFloat = 336
        static let popoverPadding: CGFloat = 12
        static let cornerRadiusPopover: CGFloat = 14
        static let cornerRadiusEventRow: CGFloat = 10
        static let cornerRadiusChip: CGFloat = 9
        
        static let eventRowHeight: CGFloat = 46
        static let reminderRowHeight: CGFloat = 32
        static let chipHeight: CGFloat = 24
        
        static let timeColumnWidth: CGFloat = 58
    }
    
    struct Colors {
        @Environment(\.colorScheme) static var colorScheme
        
        static let separator = Color(NSColor.separatorColor).opacity(0.65)
        
        static func eventOutline(color: CGColor, isDark: Bool) -> Color {
            return Color(cgColor: color).opacity(isDark ? 0.85 : 0.78)
        }
        
        static func eventFill(color: CGColor, isDark: Bool) -> Color {
            return Color(cgColor: color).opacity(isDark ? 0.09 : 0.06)
        }
        
        static func chipFill() -> Color {
            return Color.primary.opacity(0.12)
        }
    }
}
