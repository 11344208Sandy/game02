import SwiftUI

enum PlayerCharacter: String, CaseIterable, Identifiable {
    case cat
    case dog

    var id: String { rawValue }

    var name: String {
        switch self {
        case .cat:
            return "跳跳喵"
        case .dog:
            return "衝衝汪"
        }
    }

    var emoji: String {
        switch self {
        case .cat:
            return "🐱"
        case .dog:
            return "🐶"
        }
    }

    var bodyColor: Color {
        switch self {
        case .cat:
            return Color(red: 1.0, green: 0.76, blue: 0.38)
        case .dog:
            return Color(red: 0.72, green: 0.44, blue: 0.24)
        }
    }

    var accentColor: Color {
        switch self {
        case .cat:
            return Color(red: 1.0, green: 0.48, blue: 0.32)
        case .dog:
            return Color(red: 0.36, green: 0.22, blue: 0.12)
        }
    }
}
