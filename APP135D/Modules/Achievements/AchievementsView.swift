import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var journalManager: JournalManager
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(alignment: .leading, spacing: 0) {
                Text("My Achievements")
                    .font(.poppins(.bold, size: 24))
                    .foreground("FFFDFE")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 44)
                
                Text("Track your progress milestones")
                    .font(.poppins(.regular, size: 14))
                    .foreground("D1D5DB")
            }
            .padding(.horizontal, 24)
            
            ScrollView {
                // Achievements Grid
                LazyVGrid(columns: Array(repeating: .init(spacing: 16), count: 2), spacing: 16) {
                    ForEach(Achievement.allAchievements) { achievement in
                        AchievementCard(
                            achievement: achievement,
                            isUnlocked: achievementManager.isUnlocked(achievement)
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
        .background {
            Color("31383E").ignoresSafeArea()
        }
        .onAppear {
            achievementManager.checkAndUnlockAchievements(
                progressManager: progressManager,
                journalManager: journalManager
            )
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Image(achievement.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            
            VStack(spacing: 6) {
                Text(achievement.name)
                    .font(.poppins(.semibold, size: 16))
                    .foreground("F0C042")
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(.poppins(.regular, size: 12))
                    .foreground("D1D5DB")
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 4) {
                    Image(isUnlocked ? .checkmark : .lock)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 17)
                        .foregroundStyle(isUnlocked ? .victoryGreen : Color("4ADE80"))
                    
                    Text(isUnlocked ? "Unlocked" : "Locked")
                        .font(.poppins(.regular, size: 12))
                        .foregroundStyle(isUnlocked ? .victoryGreen : Color("9CA3AF"))
                }
                .padding(.horizontal, 10)
                .frame(height: 24)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isUnlocked ? Color("14532D").opacity(0.3) : Color("1F2937"))
                }
            }
        }
        .padding(16)
        .frame(height: 240, alignment: .top)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
        )
        .opacity(isUnlocked ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.3), value: isUnlocked)
    }
}

#Preview {
    AchievementsView()
        .environmentObject(AchievementManager())
        .environmentObject(ProgressManager())
        .environmentObject(JournalManager())
}
