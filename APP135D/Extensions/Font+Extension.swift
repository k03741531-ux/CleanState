import SwiftUI

extension Font {
    enum Inter: String, Fontable {
        case regular
        case semiBold
    }
    
    static func inter(_ family: Inter, size: CGFloat) -> Font {
        return .custom(family.name, fixedSize: size)
    }
}

extension Font {
    enum Poppins: String, Fontable {
        case bold
        case medium
        case regular
        case semibold
    }
    
    static func poppins(_ family: Poppins, size: CGFloat) -> Font {
        return .custom(family.name, fixedSize: size)
    }
}

protocol Fontable {
    var rawValue: String { get }
}

extension Fontable {
    var name: String {
        return String(describing: Self.self) + "-" + rawValue.capitalized
    }
}
