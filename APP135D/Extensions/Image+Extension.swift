import SwiftUI

extension Image {
    func scaleAspectFill(_ alignment: Alignment = .center) -> some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(alignment: alignment) {
                self
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
    }
}
