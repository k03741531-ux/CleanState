import SwiftUI

struct OnboardingView: View {
    @State private var currentScreen = 0
    @State private var isAnimating = false
    
    private let onboardingScreens: [OnboardingScreen] = [
        OnboardingScreen(
            title: "Break Bad Habits",
            subtitle: "Start your journey to a better you",
            description: "Track your progress, overcome temptations, and celebrate your achievements.",
            image: "onboarding1"
        ),
        OnboardingScreen(
            title: "Take Control",
            subtitle: "Empower yourself to break free",
            description: "Set clear goals and build new habits to replace the old ones.",
            image: "onboarding2"
        ),
        OnboardingScreen(
            title: "Celebrate Freedom",
            subtitle: "Every step counts",
            description: "Stay motivated with rewards and visualize your success.",
            image: "onboarding3"
        )
    ]
    
    var body: some View {
        if currentScreen < onboardingScreens.count {
            onboardingScreenView
        } else {
            GoalSetupView()
        }
    }
    
    private var onboardingScreenView: some View {
        VStack(spacing: 30) {
            // Title and subtitle with slide-in animation
            VStack(spacing: 8) {
                Text(onboardingScreens[currentScreen].title)
                    .font(.poppins(.bold, size: 30))
                    .foreground("FFFDFE")
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : -30)
                    .animation(.easeOut(duration: 0.8).delay(0.1), value: isAnimating)
                
                Text(onboardingScreens[currentScreen].subtitle)
                    .font(.poppins(.regular, size: 16))
                    .foreground("D1D5DB")
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : -20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            }
            
            // Image with scale and fade animation
            Image(onboardingScreens[currentScreen].image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxHeight: .infinity)
                .opacity(isAnimating ? 1 : 0)
                .scaleEffect(isAnimating ? 1 : 0.8)
                .animation(.easeOut(duration: 0.8).delay(0.3), value: isAnimating)
            
            // Description and button with slide-up animation
            VStack(spacing: 34) {
                Text(onboardingScreens[currentScreen].description)
                    .font(.poppins(.regular, size: 16))
                    .foreground("D1D5DB")
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Button("Next") {
                    // Animate out before transitioning
                    withAnimation(.easeIn(duration: 0.3)) {
                        isAnimating = false
                    }
                    
                    // Delay the screen change to allow exit animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        currentScreen += 1
                        
                        // Animate in the new screen if not transitioning to GoalSetupView
                        if currentScreen < onboardingScreens.count {
                            withAnimation(.easeOut(duration: 0.5)) {
                                isAnimating = true
                            }
                        }
                    }
                }
                .buttonStyle(.customCapsule)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 0.8).delay(0.5), value: isAnimating)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background {
            Color("31383E").ignoresSafeArea()
        }
        .onAppear {
            // Trigger initial animation
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }
        .id(currentScreen) // Force view recreation on screen change
    }
}

#Preview {
    OnboardingView()
}
