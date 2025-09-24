import SwiftUI

struct MotivationalCardsView: View {
    @Environment(\.goBack) private var goBack
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero
    
    private let cards = MotivationalCard.sampleCards
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button {
                    goBack()
                } label: {
                    Image(.backButton)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                }
                
                Text("Boost Your Willpower")
                    .font(.poppins(.semibold, size: 20))
                    .foreground("FFFDFE")
                    .frame(maxWidth: .infinity)
                
                Image(.backButton)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                    .opacity(0)
            }
            .frame(height: 44)
            .padding(.horizontal, 24)
            
            // Card container
            ZStack {
                ForEach(cards.indices, id: \.self) { index in
                    if index == currentIndex {
                        MotivationalCardView(card: cards[index])
                            .offset(x: dragOffset.width)
                            .rotationEffect(.degrees(Double(dragOffset.width) / 10))
                            .animation(.spring(), value: dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        let threshold: CGFloat = 100
                                        
                                        if value.translation.width > threshold {
                                            // Swipe right - previous card (with circular navigation)
                                            withAnimation(.spring()) {
                                                if currentIndex > 0 {
                                                    currentIndex -= 1
                                                } else {
                                                    // Go to last card
                                                    currentIndex = cards.count - 1
                                                }
                                            }
                                        } else if value.translation.width < -threshold {
                                            // Swipe left - next card (with circular navigation)
                                            withAnimation(.spring()) {
                                                if currentIndex < cards.count - 1 {
                                                    currentIndex += 1
                                                } else {
                                                    // Go to first card
                                                    currentIndex = 0
                                                }
                                            }
                                        }
                                        
                                        withAnimation(.spring()) {
                                            dragOffset = .zero
                                        }
                                    }
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
            
            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<cards.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.accent : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: currentIndex)
                }
            }
            .padding(.bottom, 40)
            
            // Swipe hint
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
                    .font(.caption)
                
                Text("Swipe to navigate")
                    .font(.inter(.regular, size: 12))
                    .foregroundColor(.gray)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding(.bottom, 20)
        }
        .background {
            Color("31383E").ignoresSafeArea()
        }
        .hideSystemNavBar()
    }
}

struct MotivationalCardView: View {
    let card: MotivationalCard
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Image
            Image(card.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            
            // Card type indicator
            VStack(alignment: .leading, spacing: 12) {
                Text(card.type.rawValue.capitalized)
                    .font(.inter(.semiBold, size: 12))
                    .foreground("F0C042")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Text content
                Text(card.text)
                    .font(.inter(.regular, size: 14))
                    .foreground("FFFDFE")
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(24)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("1F2937"))
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color("374151"), lineWidth: 1)
            }
        }
    }
}

#Preview {
    MotivationalCardsView()
}
