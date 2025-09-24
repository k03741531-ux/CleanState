import SwiftUI

class ProgressManager: ObservableObject {
    @AppStorage(SaveKey.lastRelapseDate) var lastRelapseDate = Date()
    @AppStorage(SaveKey.goalDays) var goalDays: Int = 0
    
    var timeComponents: (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let now = Date()
        let timeInterval = now.timeIntervalSince(lastRelapseDate)
        
        let days = Int(timeInterval) / 86400
        let hours = (Int(timeInterval) % 86400) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        return (days: days, hours: hours, minutes: minutes, seconds: seconds)
    }
    
    var progressPercentage: Double {
        guard goalDays > 0 else { return 0 }
        let currentDays = timeComponents.days
        return min(Double(currentDays) / Double(goalDays), 1.0)
    }
    
    func relapse() {
        lastRelapseDate = Date()
    }
    
    func resetProgress() {
        lastRelapseDate = Date()
    }
}
