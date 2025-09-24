import SwiftUI

extension Color {
    init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 17) & 0xF0, (int >> 4 * 17) & 0xF0, int * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // Dashboard specific colors
    static let dashboardBackground = Color("31383E")
    static let cardBackground = Color("3A4147")
    static let secondaryBackground = Color("4A5258")
    static let accent = Color("F0C042")
    static let relapseRed = Color("E74C3C")
    static let cravingOrange = Color("F39C12")
    static let victoryGreen = Color("28A745")
    static let noteGray = Color("6C757D")
}

extension View {
    func foreground(_ hex: String) -> some View {
        foregroundStyle(Color(hex))
    }
}