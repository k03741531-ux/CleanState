import SwiftUI

struct RoundedCorner: InsettableShape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var roundedCorner = self
        roundedCorner.insetAmount += amount
        return roundedCorner
    }
}

extension UIRectCorner {
    static var top: UIRectCorner {
        return [.topLeft, .topRight]
    }
    
    static var bottom: UIRectCorner {
        return [.bottomLeft, .bottomRight]
    }

    static var left: UIRectCorner {
        return [.topLeft, .bottomLeft]
    }
    
    static var right: UIRectCorner {
        return [.topRight, .bottomRight]
    }
}

extension View {
    func roundedCorners(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
