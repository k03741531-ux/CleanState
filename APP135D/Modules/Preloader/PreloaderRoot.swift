import SwiftUI

struct PreloaderView: View {
    private let images = (1...10).map { "a\($0)" }
    private let numberOfParticles = 10 // Number of simultaneous images
    private let baseAnimationDuration: Double = 0.8 // Base duration for animation
    private let fountainHeight: CGFloat = 200 // Max height for fountain effect
    
    // State for each particle's animation properties
    @State private var particles: [(index: Int, offsetY: CGFloat, offsetX: CGFloat, scale: CGFloat, opacity: Double, angle: CGFloat, duration: Double)] = []
    
    var body: some View {
        ZStack {
            Color("31383E")
                .ignoresSafeArea()
            
            ZStack {
                ForEach(particles.indices, id: \.self) { i in
                    Image(images[particles[i].index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .scaleEffect(particles[i].scale)
                        .opacity(particles[i].opacity)
                        .offset(x: particles[i].offsetX, y: particles[i].offsetY)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            initializeParticles()
            startAnimation()
        }
    }
    
    private func initializeParticles() {
        particles = (0..<numberOfParticles).map { _ in
            (
                index: Int.random(in: 0..<images.count),
                offsetY: 0,
                offsetX: 0,
                scale: 0.5,
                opacity: 0.0,
                angle: CGFloat.random(in: -30...30), // Random angle for spread
                duration: baseAnimationDuration + Double.random(in: -0.3...0.3) // Random duration
            )
        }
    }
    
    private func startAnimation() {
        for i in particles.indices {
            // Stagger start times slightly
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                animateParticle(index: i)
            }
        }
    }
    
    private func animateParticle(index: Int) {
        // Reset particle properties
        particles[index].offsetY = 0
        particles[index].offsetX = 0
        particles[index].scale = 0.5
        particles[index].opacity = 0.0
        particles[index].index = Int.random(in: 0..<images.count)
        particles[index].angle = CGFloat.random(in: -30...30)
        particles[index].duration = baseAnimationDuration + Double.random(in: -0.3...0.3)
        
        // Calculate horizontal offset based on angle
        let radianAngle = particles[index].angle * .pi / 180
        let finalOffsetX = fountainHeight * tan(radianAngle)
        
        // Animate
        withAnimation(.easeOut(duration: particles[index].duration)) {
            particles[index].offsetY = -fountainHeight
            particles[index].offsetX = finalOffsetX
            particles[index].scale = 1.0
            particles[index].opacity = 1.0
        }
        
        // Schedule next animation cycle
        DispatchQueue.main.asyncAfter(deadline: .now() + particles[index].duration) {
            animateParticle(index: index)
        }
    }
}

#Preview {
    PreloaderView()
}
