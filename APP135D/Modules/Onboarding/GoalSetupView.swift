import SwiftUI

struct GoalSetupView: View {
    @AppStorage(SaveKey.userHabit) private var userHabit = ""
    @AppStorage(SaveKey.goalDays) private var goalDays = 0
    @AppStorage(SaveKey.quitReason) private var quitReason = ""
    @AppStorage(SaveKey.reward) private var reward = ""
    @AppStorage(SaveKey.startDate) var startDate = Date()
    @AppStorage(SaveKey.lastRelapseDate) var lastRelapseDate = Date()
    @AppStorage(SaveKey.isOnboarding) var isOnboarding = true
    
    @State private var tempHabit = ""
    @State private var tempGoalDays = ""
    @State private var tempQuitReason = ""
    @State private var tempReward = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Set Your Goal")
                        .font(.poppins(.bold, size: 24))
                        .foreground("FFFDFE")
                    
                    Text("Define your habit-breaking journey")
                        .font(.poppins(.regular, size: 14))
                        .foreground("D1D5DB")
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Habit I want to break:")
                        .font(.poppins(.medium, size: 14))
                        .foreground("FFFDFE")
                    
                    MainTextField(placeholder: "e.g., Smoking, Social Media, Junk Food...", text: $tempHabit)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("My Goal (days without habit):")
                        .font(.poppins(.medium, size: 14))
                        .foreground("FFFDFE")
                    
                    HStack(spacing: 12) {
                        MainTextField(placeholder: "Days", text: $tempGoalDays)
                            .keyboardType(.numberPad)
                            .onChange(of: tempGoalDays) { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                let limited = String(filtered.prefix(3)) // limit to 3 characters
                                if limited != newValue {
                                    tempGoalDays = limited
                                }
                            }
                        
                        Text("days")
                            .font(.poppins(.regular, size: 16))
                            .foreground("D1D5DB")
                            .frame(width: 71, height: 56)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("3D454C"))
                            }
                    }
                    
                    HStack(spacing: 8) {
                        dayButton(title: "7\ndays", days: 7)
                        dayButton(title: "30\ndays", days: 30)
                        dayButton(title: "90\ndays", days: 90)
                        dayButton(title: "1\nyear", days: 360)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        Text("Reason for Quitting: ")
                            .font(.poppins(.medium, size: 14))
                            .foreground("FFFDFE")
                        Text("(optional)")
                            .font(.poppins(.medium, size: 12))
                            .foreground("9CA3AF")
                    }
                    
                    MainTextField(
                        placeholder: "Why do you want to break this habit?\nWhat will change in your life?",
                        text: $tempQuitReason,
                        isMultiline: true
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        Text("My Reward for Success: ")
                            .font(.poppins(.medium, size: 14))
                            .foreground("FFFDFE")
                        Text("(optional)")
                            .font(.poppins(.medium, size: 12))
                            .foreground("9CA3AF")
                    }
                    
                    MainTextField(
                        placeholder: "What will you treat yourself to when you reach your goal?",
                        text: $tempReward,
                        isMultiline: true
                    )
                }
                
                Button("Start") {
                    userHabit = tempHabit
                    goalDays = Int(tempGoalDays) ?? 0
                    quitReason = tempQuitReason
                    reward = tempReward
                    startDate = Date()
                    lastRelapseDate = Date()
                    isOnboarding = false
                }
                .buttonStyle(.customCapsule)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 30)
        }
        .padding(.top, 1)
        .background {
            Color("31383E")
                .ignoresSafeArea()
        }
        .addDoneButtonToKeyboard()
    }
    
    private func dayButton(title: String, days: Int) -> some View {
        Button {
            tempGoalDays = String(days)
        } label: {
            Text(title)
                .font(.poppins(.regular, size: 14))
                .foreground("FFFDFE")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("3D454C"))
                }
        }
    }
}

#Preview {
    GoalSetupView()
}
