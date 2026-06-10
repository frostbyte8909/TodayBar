import Foundation
import EventKit

struct QuickAddParser {
    struct ParseResult {
        let title: String
        let date: Date
    }
    
    static func parse(_ input: String) -> ParseResult? {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
            let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
            
            guard let match = matches.first, let date = match.date else {
                return nil
            }
            
            let dateRange = match.range
            if let stringRange = Range(dateRange, in: input) {
                var title = input
                title.removeSubrange(stringRange)
                title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if title.hasSuffix(" at") || title.hasSuffix(" on") || title.hasSuffix(" in") {
                    title.removeLast(3)
                }
                
                if title.isEmpty { title = "New Event" }
                return ParseResult(title: title.trimmingCharacters(in: .whitespacesAndNewlines), date: date)
            }
        } catch {
            print("Failed to initialize NSDataDetector: \(error)")
        }
        return nil
    }
}
