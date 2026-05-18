import SwiftUI

struct Obstacle: Identifiable, Equatable {
    let id = UUID()
    let kind: ObstacleKind
    var xPosition: CGFloat
    let size: CGSize
    var hasScored: Bool = false

    var collisionRect: CGRect {
        CGRect(
            x: xPosition - size.width * 0.38,
            y: -size.height * 0.86,
            width: size.width * 0.76,
            height: size.height * 0.76
        )
    }
}

enum ObstacleKind: CaseIterable {
    case dogCan
    case catTower
    case yarnBall
    case petBowl
    case catTeaser
    case bone
    case box
    case toyBall

    var title: String {
        switch self {
        case .dogCan:
            return "汪罐罐"
        case .catTower:
            return "喵跳台"
        case .yarnBall:
            return "毛線球"
        case .petBowl:
            return "飯飯碗"
        case .catTeaser:
            return "逗貓棒"
        case .bone:
            return "小骨頭"
        case .box:
            return "紙箱堡"
        case .toyBall:
            return "玩具球"
        }
    }

    var emoji: String {
        switch self {
        case .dogCan:
            return "🥫"
        case .catTower:
            return "🪜"
        case .yarnBall:
            return "🧶"
        case .petBowl:
            return "🥣"
        case .catTeaser:
            return "🪄"
        case .bone:
            return "🦴"
        case .box:
            return "📦"
        case .toyBall:
            return "🎾"
        }
    }

    var size: CGSize {
        switch self {
        case .catTower:
            return CGSize(width: 62, height: 92)
        case .catTeaser:
            return CGSize(width: 50, height: 76)
        case .box:
            return CGSize(width: 68, height: 58)
        default:
            return CGSize(width: 54, height: 54)
        }
    }
}
