import SwiftUI

struct ObstacleView: View {
    let obstacle: Obstacle

    var body: some View {
        VStack(spacing: 1) {
            Text(obstacle.kind.emoji)
                .font(.system(size: emojiSize))

            Text(obstacle.kind.title)
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .foregroundStyle(.brown)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(width: obstacle.size.width, height: obstacle.size.height)
    }

    private var emojiSize: CGFloat {
        min(obstacle.size.width, obstacle.size.height) * 0.66
    }
}

#Preview {
    HStack {
        ObstacleView(obstacle: Obstacle(kind: .dogCan, xPosition: 0, size: ObstacleKind.dogCan.size))
        ObstacleView(obstacle: Obstacle(kind: .catTower, xPosition: 0, size: ObstacleKind.catTower.size))
    }
    .padding()
}
