import SwiftUI

struct MotivationView: View {
    @State private var showingMotivationalCards = false
    @State private var dailyQuote = MotivationalCard.sampleCards.randomElement()
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(alignment: .leading, spacing: 0) {
                Text("Stay Motivated")
                    .font(.poppins(.bold, size: 24))
                    .foreground("FFFDFE")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 44)
                
                Text("Daily inspiration to keep you going")
                    .font(.poppins(.regular, size: 14))
                    .foreground("D1D5DB")
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 24) {
                VStack(spacing: 5) {
                    Text("Daily Quote")
                        .font(.poppins(.regular, size: 14))
                        .foreground("D1D5DB")
                    
                    Text("\"\(dailyMotivationQuote())\"")
                        .font(.poppins(.semibold, size: 20))
                        .foreground("FFFDFE")
                        .multilineTextAlignment(.center)
                }
                
                Image(.motivation)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                NavigationLink {
                    MotivationalCardsView()
                } label: {
                    HStack(spacing: 8) {
                        Image(.heart)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                        
                        Text("Feeling Low?")
                    }
                }
                .buttonStyle(.customCapsule)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 24)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("3D454C"))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        }
        .background {
            Color("31383E").ignoresSafeArea()
        }
    }
    
    private func dailyMotivationQuote() -> String {
        let quotes: [String] = [
               "You’re not starting from scratch. You’re starting from experience.",
               "Your habit doesn’t control you. You control your choices.",
               "Small victories lead to big change. Celebrate them.",
               "Quitting is hard, but regret is harder.",
               "Today is a clean slate. Use it wisely.",
               "Discipline is choosing what you want most over what you want now.",
               "The urge will pass. Your strength will stay.",
               "This moment is a chance to say no—and mean it.",
               "You’re doing something powerful: taking back your life.",
               "Every craving resisted is a step toward freedom.",
               "Growth is uncomfortable. So is staying the same. Choose growth.",
               "You made it through yesterday. You’ll make it through today.",
               "Consistency beats intensity. Just keep showing up.",
               "Change is hard at first, messy in the middle, but worth it in the end.",
               "You are creating a new version of yourself. Be proud of the effort.",
               "Resist. Reflect. Repeat. You’re building resilience.",
               "Don’t quit on a bad day. Rest. Then continue.",
               "Success is the sum of small efforts repeated daily.",
               "The strongest you is the one who shows up anyway.",
               "Today is one more day of winning against the old you."
           ]

        guard !quotes.isEmpty else { return "Stay strong. Your journey matters." }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % quotes.count

        return quotes[index]
    }
}

#Preview {
    MotivationView()
}
