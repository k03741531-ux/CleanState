import SwiftUI
import UIKit

final class OrientationInfo {
    static func updateOrientation(_ orientationLock: UIInterfaceOrientationMask) {
        if #available(iOS 16.0, *) {
            UIApplication.shared.connectedScenes.forEach { scene in
                if let windowScene = scene as? UIWindowScene {
                    windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                    windowScene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                }
            }
        } else {
            UIApplication.shared.connectedScenes.forEach { scene in
                if scene is UIWindowScene {
                    if orientationLock == .landscape {
                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                    } else {
                        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    }
                }
            }
        }
    }
}

extension View {
    @ViewBuilder
    func lockOrientation(_ orientation: UIInterfaceOrientationMask) -> some View {
        self
//            .onAppear() {
//                AppDelegate.orientation = orientation
//            }
//            .onDisappear() {
//                let currentOrientation = AppDelegate.orientation
//                AppDelegate.orientation = currentOrientation
//            }
    }
}
