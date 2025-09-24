import SwiftUI

struct Achievement: Identifiable, Codable, Equatable {
    var id: String { name }
    let name: String
    let description: String
    let icon: String
    let type: AchievementType
    let requirement: Int
    let category: AchievementCategory
    
    enum AchievementType: String, Codable {
        case daysBased = "days"
        case cravingsBased = "cravings"
        case relapseBased = "relapse"
        case goalBased = "goal"
    }
    
    enum AchievementCategory: String, Codable {
        case milestone = "milestone"
        case strength = "strength"
        case progress = "progress"
    }
    
    static let allAchievements: [Achievement] = [
        // Milestone achievements (days based)
        Achievement(name: "First Step", description: "Stay one full day without your habit.", icon: "a1", type: .daysBased, requirement: 1, category: .milestone),
        Achievement(name: "Three Days Strong", description: "Stay three full days without your habit.", icon: "a2", type: .daysBased, requirement: 3, category: .milestone),
        Achievement(name: "Week Without", description: "Stay one full week (7 days) without your habit.", icon: "a3", type: .daysBased, requirement: 7, category: .milestone),
        Achievement(name: "Breaking the Chain", description: "Stay two full weeks (14 days) without your habit.", icon: "a4", type: .daysBased, requirement: 14, category: .milestone),
        Achievement(name: "Halfway There", description: "Reach half of your initial goal duration.", icon: "a5", type: .goalBased, requirement: 50, category: .progress),
        Achievement(name: "Goal Achieved", description: "Reach your initial goal duration.", icon: "a6", type: .goalBased, requirement: 100, category: .progress),
        
        // Strength achievements (cravings based)
        Achievement(name: "Stronger Than Craving", description: "Log 5 cravings without relapsing immediately.", icon: "a7", type: .cravingsBased, requirement: 5, category: .strength),
        Achievement(name: "Craving Master", description: "Log 10 cravings without relapsing immediately.", icon: "a8", type: .cravingsBased, requirement: 10, category: .strength),
        Achievement(name: "Resilient Fighter", description: "Log 20 cravings without relapsing immediately.", icon: "a9", type: .cravingsBased, requirement: 20, category: .strength),
        Achievement(name: "New Beginning", description: "Log your first relapse (and hopefully start again stronger).", icon: "a10", type: .relapseBased, requirement: 1, category: .progress)
    ]
}

class AchievementManager: ObservableObject {
    @AppStorage(SaveKey.unlockedAchievements) var unlockedAchievements: [Achievement] = []
    
    func checkAndUnlockAchievements(progressManager: ProgressManager, journalManager: JournalManager) {
        for achievement in Achievement.allAchievements {
            if !isUnlocked(achievement) {
                if shouldUnlock(achievement, progressManager: progressManager, journalManager: journalManager) {
                    unlock(achievement)
                }
            }
        }
    }
    
    func isUnlocked(_ achievement: Achievement) -> Bool {
        return unlockedAchievements.contains(achievement)
    }
    
    private func unlock(_ achievement: Achievement) {
        unlockedAchievements.append(achievement)
    }
    
    private func shouldUnlock(_ achievement: Achievement, progressManager: ProgressManager, journalManager: JournalManager) -> Bool {
        switch achievement.type {
        case .daysBased:
            return progressManager.timeComponents.days >= achievement.requirement
        case .cravingsBased:
            let cravingCount = journalManager.entries.filter { $0.type == .craving }.count
            return cravingCount >= achievement.requirement
        case .relapseBased:
            let relapseCount = journalManager.entries.filter { $0.type == .relapse }.count
            return relapseCount >= achievement.requirement
        case .goalBased:
            return progressManager.progressPercentage * 100 >= Double(achievement.requirement)
        }
    }
    
    var unlockedCount: Int {
        return unlockedAchievements.count
    }
}
