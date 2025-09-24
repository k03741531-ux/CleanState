import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var journalManager: JournalManager

    @State private var showRelapseAlert = false
    @State private var timer: Timer?
    @State private var currentTime = Date()
    
    var body: some View {
        VStack(spacing: 24) {
            headerView
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 24) {
                        progressCircleView
                        timeComponentsView
                    }
                    .padding(24)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("3D454C"))
                    }
                    
                    goalProgressView
                    actionButtonsView
                    motivationView
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
        .background(Color("31383E"))
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .alert("Are you sure?", isPresented: $showRelapseAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Yes, Reset", role: .destructive) {
                progressManager.relapse()
            }
        } message: {
            Text("This will reset your current streak progress.")
        }
    }
    
    private var headerView: some View {
        Text("My Progress")
            .font(.poppins(.bold, size: 24))
            .foreground("FFFDFE")
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 44)
            .padding(.horizontal, 24)
    }
    
    private var progressCircleView: some View {
        let components = progressManager.timeComponents
        
        return ZStack {
            // Background circle
            Circle()
                .stroke(Color("4A5258"), lineWidth: 4)
                .frame(width: 160, height: 160)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progressManager.progressPercentage)
                .stroke(
                    Color("F0C042"),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 160, height: 160)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progressManager.progressPercentage)
            
            // Center content
            VStack(spacing: 0) {
                Text("Current streak")
            
                Text(String(components.days))
                    .font(.poppins(.bold, size: 30))
                    .foreground("F0C042")
                
                Text("days")
            }
            .font(.poppins(.regular, size: 14))
            .foreground("D1D5DB")
        }
    }
    
    private var timeComponentsView: some View {
        let components = progressManager.timeComponents
        
        return HStack(spacing: 0) {
            TimeComponentView(value: components.days, label: "Days")
            TimeComponentView(value: components.hours, label: "Hours")
            TimeComponentView(value: components.minutes, label: "Minutes")
            TimeComponentView(value: components.seconds, label: "Seconds")
        }
    }
    
    private var goalProgressView: some View {
        let components = progressManager.timeComponents
        let goalDays = progressManager.goalDays
        
        return VStack(spacing: 8) {
            HStack {
                Text("Goal Progress")
                Spacer()
                Text("\(components.days)/\(goalDays) days")
                    
            }
            .font(.poppins(.medium, size: 14))
            .foreground("FFFDFE")
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color("31383E"))
                        .frame(height: 12)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color("F0C042"))
                        .frame(width: geometry.size.width * progressManager.progressPercentage, height: 12)
                        .animation(.easeInOut(duration: 0.5), value: progressManager.progressPercentage)
                }
            }
            .frame(height: 12)
            .padding(.bottom, 8)
            
            // Milestone markers
            HStack {
                Text("Start")
                    .background(Color("3D454C"))
                Spacer()
                Text("Goal: \(goalDays) days")
                    .background(Color("3D454C"))
            }
            .font(.poppins(.regular, size: 12))
            .foreground("D1D5DB")
            .frame(height: 16)
            .background {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        Rectangle()
                            .fill(Color("31383E"))
                            .frame(height: 12)
                        
                        // Progress
                        Rectangle()
                            .fill(Color("F0C042"))
                            .frame(width: geometry.size.width * progressManager.progressPercentage, height: 12)
                            .animation(.easeInOut(duration: 0.5), value: progressManager.progressPercentage)
                    }
                }
                .frame(height: 12)
                .mask {
                    // Create mask with gaps
                    GeometryReader { maskGeometry in
                        let gapPositions: [Double] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
                        let gapWidth: CGFloat = maskGeometry.size.width * 0.09
                        ZStack {
                            // Base rectangle
                            Rectangle()
                                .fill(Color.black)
                            
                            // Cut out gaps
                            ForEach(gapPositions.indices, id: \.self) { index in
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: gapWidth, height: 12)
                                    .position(
                                        x: maskGeometry.size.width * gapPositions[index],
                                        y: 6
                                    )
                                    .blendMode(.destinationOut)
                            }
                        }
                        .compositingGroup()
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("3D454C"))
        )
    }
    
    private var actionButtonsView: some View {
        HStack(spacing: 16) {
            // Relapse Button
            Button(action: {
                showRelapseAlert = true
            }) {
                VStack(spacing: 4) {
                    Image(.dashboardRelapse)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 28)
                        
                    Text("Relapse")
                        .font(.poppins(.medium, size: 14))
                        .foreground("FFFDFE")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("EF4444"))
                }
            }
            
            // Log Craving Button
            NavigationLink {
                AddEditEntryView()
            } label: {
                VStack(spacing: 4) {
                    Image(.dashboardCraving)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 28)
                        
                    Text("Log Craving")
                        .font(.poppins(.medium, size: 14))
                        .foreground("FFFDFE")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("3D454C"))
                }
            }
        }
    }
    
    private var motivationView: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            Image(.dashboardMotivation)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Motivation")
                    .font(.poppins(.medium, size: 16))
                    .foreground("FFFDFE")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\"\(quoteOfTheDay())\"")
                    .font(.poppins(.regular, size: 14))
                    .foreground("D1D5DB")
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("3D454C"))
        )
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            currentTime = Date()
            progressManager.objectWillChange.send()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func quoteOfTheDay() -> String {
        let quotes: [String] = [
            "Every day is a new opportunity to strengthen your resolve. You've got this!",
            "Progress, not perfection. One step at a time.",
            "The only way out is through. Keep going.",
            "You are stronger than you think.",
            "Cravings are temporary. Strength is permanent.",
            "Even a single step forward is a step away from the past.",
            "Don't let one slip define your journey. Begin again—stronger.",
            "Each second without your habit is a win. Celebrate it.",
            "Believe in the version of you who started this journey.",
            "The future depends on what you do today.",
            "It’s not about never falling—it’s about always getting back up.",
            "Discomfort is the cost of growth. You’re growing.",
            "Break the chain, reclaim your power.",
            "Habits don't define you—choices do.",
            "You’ve already started. That’s the hardest part.",
            "Willpower grows when you use it. Keep training it.",
            "Your mind is your strongest muscle. Strengthen it daily.",
            "Freedom from habit is worth every effort.",
            "Healing begins the moment you decide to change.",
            "Today, you chose courage over comfort. That matters."
        ]
        
        // Use the current day of the year to get a consistent quote each day
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % quotes.count
        
        return quotes[index]
    }
}

struct TimeComponentView: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.poppins(.regular, size: 14))
                .foreground("D1D5DB")
            
            Text(String(format: "%02d", value))
                .font(.poppins(.bold, size: 24))
                .foreground("F0C042")
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DashboardView()
        .environmentObject(ProgressManager())
        .environmentObject(JournalManager())
}
