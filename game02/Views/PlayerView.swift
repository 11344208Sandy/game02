import SwiftUI

struct PlayerView: View {
    let character: PlayerCharacter
    let state: PlayerRunState
    let rotationDegrees: Double

    var body: some View {
        Text(character.emoji)
            .font(.system(size: 58))
            .scaleEffect(state == .hit ? 0.92 : 1)
            .rotationEffect(.degrees(displayRotationDegrees))
            .frame(width: 70, height: 70)
            .animation(.spring(response: 0.22, dampingFraction: 0.62), value: state)
    }

    private var displayRotationDegrees: Double {
        switch state {
        case .running:
            return -4
        case .jumping:
            return rotationDegrees
        case .hit:
            return -14
        }
    }
}

#Preview {
    HStack(spacing: 24) {
        PlayerView(character: .cat, state: .running, rotationDegrees: 0)
        PlayerView(character: .dog, state: .jumping, rotationDegrees: 180)
    }
    .padding()
}
