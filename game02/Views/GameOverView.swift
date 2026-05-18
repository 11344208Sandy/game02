import SwiftUI

struct GameOverView: View {
    let score: Int
    let highScore: Int
    let character: PlayerCharacter
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("撞到啦！")
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(.brown)

            VStack(spacing: 6) {
                Text("\(character.emoji) \(character.name) 跑了 \(score) 分")

                Label("最高分 \(highScore)", systemImage: "crown.fill")
                    .foregroundStyle(.orange)
            }
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button(action: onRestart) {
                    Label("再跑一次", systemImage: "arrow.clockwise")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)

                Button(action: onHome) {
                    Label("換角色", systemImage: "pawprint.fill")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.brown)
            }
        }
        .padding(22)
        .frame(maxWidth: 360)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.2), radius: 18, x: 0, y: 10)
        .padding(24)
    }
}

#Preview {
    GameOverView(score: 246, highScore: 500, character: .dog, onRestart: {}, onHome: {})
        .background(Color.cyan.opacity(0.25))
}
