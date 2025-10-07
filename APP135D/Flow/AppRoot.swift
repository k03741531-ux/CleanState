import SwiftUI

struct AppRoot: View {
    @State private var isLoading = true
    @AppStorage(SaveKey.isOnboarding) var isOnboarding = true
    
    @StateObject private var progressManager = ProgressManager()
    @StateObject private var achievementManager = AchievementManager()
    @StateObject private var journalManager = JournalManager()

    var body: some View {
        rootView
            .buttonStyle(.plain)
            .dynamicTypeSize(.large)
        //    .lockOrientation(AppDelegate.orientation)
            .animation(.default, value: isLoading)
            .animation(.default, value: isOnboarding)
    }
    
    
    @ViewBuilder
    private var rootView: some View {
        ZStack {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    TabsView()
                }
                .environmentObject(progressManager)
                .environmentObject(achievementManager)
                .environmentObject(journalManager)
            } else {
                // Fallback on earlier versions
            }

            if isOnboarding {
                OnboardingView()
                    .zIndex(1)
            }
            
            if isLoading {
                PreloaderView()
                    .zIndex(2)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            }
        }
    }
}
