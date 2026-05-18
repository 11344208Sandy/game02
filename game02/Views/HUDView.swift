import SwiftUI

struct HUDView: View {
    let score: Int
    let highScore: Int
    let character: PlayerCharacter
    let onHome: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")

                Text("\(score)")
                    .contentTransition(.numericText())
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
                    .monospacedDigit()
            }
            .font(.system(size: 22, weight: .heavy, design: .rounded))
            .foregroundStyle(.orange)
            .frame(minWidth: 118, minHeight: 52)
            .padding(.horizontal, 14)
            .background(.white.opacity(0.9), in: Capsule())

            Label("最高 \(highScore)", systemImage: "crown.fill")
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(.brown)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(.white.opacity(0.82), in: Capsule())

            Text(character.emoji)
                .font(.system(size: 26))
                .frame(width: 52, height: 52)
                .background(.white.opacity(0.82), in: Circle())

            Spacer()

            Button(action: onHome) {
                Image(systemName: "house.fill")
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.88), in: Circle())
            }
            .buttonStyle(.plain)
            .foregroundStyle(.brown)
            .accessibilityLabel("回到角色選擇")
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
    }
}

#Preview {
    HUDView(score: 128, highScore: 320, character: .cat, onHome: {})
        .background(Color.cyan.opacity(0.2))
}
