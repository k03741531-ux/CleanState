//
//  DeviceIDProvider.swift
//  iGService
//
//  Created by D K on 22.09.2025.
//

import Foundation

enum DeviceIDProvider {
    static func persistedLowerUUID() -> String {
        if let v = UserDefaults.standard.string(forKey: MyConstants.udidKey) { return v }
        let u = UUID().uuidString.lowercased()
        UserDefaults.standard.set(u, forKey: MyConstants.udidKey)
        print("🆔 Persisted UUID v4 lower = \(u)")
        return u
    }
}
