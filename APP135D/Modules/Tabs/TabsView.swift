import SwiftUI

struct TabsView: View {
    @State private var currentTab: Tab = .dashboard

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch currentTab {
                case .dashboard:
                    DashboardView()
                case .achievements:
                    AchievementsView()
                case .journal:
                    JournalView()
                case .motivation:
                    MotivationView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            TabsBarView(currentTab: $currentTab)
        }
        .background {
            Color("31383E").ignoresSafeArea()
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct TabsBarView: View {
    @Binding var currentTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases) { tab in
                VStack(spacing: 6) {
                    Image(tab.icon)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(tab.title)
                        .font(.poppins(.regular, size: 12))
                }
                .foreground(tab == currentTab ? "F0C042" : "9CA3AF")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
                .onTapGesture {
                    currentTab = tab
                }
            }
        }
        .padding(.horizontal, 10)
        .background {
            ZStack {
                RoundedCorner(radius: 12, corners: .top)
                    .fill(Color.white.opacity(0.3))
                
                RoundedCorner(radius: 12, corners: .top)
                    .fill(Color("3D454C"))
                    .padding(.top, 1)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    TabsView()
}
