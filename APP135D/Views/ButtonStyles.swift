import SwiftUI

struct CustomCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.poppins(.semibold, size: 16))
            .foreground("31383E")
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color("F0C042"))
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
extension ButtonStyle where Self == CustomCapsuleButtonStyle {
    static var customCapsule: Self { .init()}
}

struct CustomRoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.poppins(.semibold, size: 16))
            .foreground("31383E")
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("F0C042"))
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
extension ButtonStyle where Self == CustomRoundedButtonStyle {
    static var customRounded: Self { .init()}
}

#Preview {
    VStack {
        Button("Title", action: {})
            .buttonStyle(.customCapsule)
        
        Button("Title", action: {})
            .buttonStyle(.customRounded)
    }
}
