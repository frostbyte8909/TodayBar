import Foundation
import EventKit

struct MeetingParser {
    enum MeetingPlatform: String {
        case zoom = "Zoom"
        case meet = "Google Meet"
        case teams = "Microsoft Teams"
        case generic = "Meeting"
        
        var iconName: String {
            switch self {
            case .zoom, .meet, .teams: return "video.fill"
            case .generic: return "link"
            }
        }
    }
    
    struct MeetingLink {
        let url: URL
        let platform: MeetingPlatform
    }
    
    static func extractMeetingLink(from event: EKEvent) -> MeetingLink? {
        let textToSearch = [event.url?.absoluteString, event.notes]
            .compactMap { $0 }
            .joined(separator: " ")
        
        if let range = textToSearch.range(of: "https://[a-zA-Z0-9-]*\\.zoom\\.us/[a-zA-Z0-9/-_]+", options: .regularExpression),
           let url = URL(string: String(textToSearch[range])) {
            return MeetingLink(url: url, platform: .zoom)
        }
        
        if let range = textToSearch.range(of: "https://meet\\.google\\.com/[a-zA-Z0-9-]+", options: .regularExpression),
           let url = URL(string: String(textToSearch[range])) {
            return MeetingLink(url: url, platform: .meet)
        }
        
        if let range = textToSearch.range(of: "https://teams\\.microsoft\\.com/l/meetup-join/[^\\s\"']+", options: .regularExpression),
           let url = URL(string: String(textToSearch[range])) {
            return MeetingLink(url: url, platform: .teams)
        }
        
        if let eventURL = event.url, eventURL.absoluteString.contains("meet") || eventURL.absoluteString.contains("zoom") || eventURL.absoluteString.contains("teams") {
             return MeetingLink(url: eventURL, platform: .generic)
        }
        
        return nil
    }
}
