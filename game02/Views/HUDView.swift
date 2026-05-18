import SwiftUI

struct HUDView: View {
    let score: Int
    let highScore: Int
    let character: PlayerCharacter
    let onHome: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 12) {
                scoreCapsule
                highScoreCapsule
            }

            characterBadge

            Spacer()

            Button(action: onHome) {
                Image(systemName: "house.fill")
                    .font(.system(size: 15, weight: .bold))
                    .frame(width: 38, height: 38)
                    .background(.white.opacity(0.88), in: Circle())
            }
            .buttonStyle(.plain)
            .foregroundStyle(.brown)
            .accessibilityLabel("回到角色選擇")
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
    }

    private var scoreCapsule: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")

            Text("\(score)")
                .contentTransition(.numericText())
                .lineLimit(1)
                .minimumScaleFactor(0.82)
                .monospacedDigit()
        }
        .font(.system(size: 19, weight: .heavy, design: .rounded))
        .foregroundStyle(.orange)
        .frame(width: 112, height: 44)
        .background(.white.opacity(0.9), in: Capsule())
    }

    private var highScoreCapsule: some View {
        HStack(spacing: 5) {
            Image(systemName: "crown.fill")

            Text("最高 \(highScore)")
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .monospacedDigit()
        }
        .font(.system(size: 12, weight: .heavy, design: .rounded))
        .foregroundStyle(.brown)
        .frame(width: 98, height: 38)
        .background(.white.opacity(0.82), in: Capsule())
    }

    private var characterBadge: some View {
        Text(character.emoji)
            .font(.system(size: 22))
            .frame(width: 42, height: 42)
            .background(.white.opacity(0.82), in: Circle())
    }
}

#Preview {
    HUDView(score: 128, highScore: 320, character: .cat, onHome: {})
        .background(Color.cyan.opacity(0.2))
}
