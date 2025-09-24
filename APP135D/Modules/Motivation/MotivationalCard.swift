import Foundation

struct MotivationalCard: Identifiable, Codable {
    let id: Int
    let type: CardType
    let text: String
    let imageName: String
    
    enum CardType: String, Codable {
        case quote = "quote"
        case tip = "tip"
        case fact = "fact"
    }
}

// MARK: - Sample Data
extension MotivationalCard {
    static let sampleCards: [MotivationalCard] = [
        MotivationalCard(
            id: 1,
            type: .quote,
            text: "Every journey begins with a single step. The path may be challenging, but the light ahead guides your way.",
            imageName: "m1"
        ),
        MotivationalCard(
            id: 2,
            type: .tip,
            text: "Schedule your workouts like important meetings. Planning ahead increases your commitment by 40%.",
            imageName: "m2"
        ),
        MotivationalCard(
            id: 3,
            type: .quote,
            text: "Strength doesn't come from what you can do. It comes from overcoming what you thought you couldn't.",
            imageName: "m3"
        ),
        MotivationalCard(
            id: 4,
            type: .tip,
            text: "Replace bad habits with positive activities. Read, exercise, or listen to music when cravings hit.",
            imageName: "m4"
        ),
        MotivationalCard(
            id: 5,
            type: .quote,
            text: "Progress is progress, no matter how small. Every step forward counts on your journey.",
            imageName: "m5"
        ),
        MotivationalCard(
            id: 6,
            type: .fact,
            text: "Your heart rate returns to normal 20 minutes after exercise, and your body continues burning calories for hours.",
            imageName: "m6"
        ),
        MotivationalCard(
            id: 7,
            type: .tip,
            text: "Celebrate your milestones. Reward yourself for hitting your goals and acknowledge your progress.",
            imageName: "m7"
        ),
        MotivationalCard(
            id: 8,
            type: .quote,
            text: "The future depends on what you do today. Every choice you make shapes your tomorrow.",
            imageName: "m8"
        ),
        MotivationalCard(
            id: 9,
            type: .tip,
            text: "Stay hydrated. Sometimes thirst is mistaken for hunger or craving. Drink water first.",
            imageName: "m9"
        ),
        MotivationalCard(
            id: 10,
            type: .quote,
            text: "Believe in yourself. You have the strength to overcome any challenge that comes your way.",
            imageName: "m10"
        )
    ]
}