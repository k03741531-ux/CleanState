import Foundation

enum Tab: Int, Identifiable, CaseIterable {
    case dashboard = 1
    case achievements
    case journal
    case motivation
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .achievements: return "Achievements"
        case .journal: return "Journal"
        case .motivation: return "Motivation"
        }
    }
    
    var icon: String {
        return "tab" + String(rawValue)
    }
}
