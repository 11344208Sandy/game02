import SwiftUI

struct GameView: View {
    let viewModel: GameViewModel

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let groundY = size.height * 0.78

            ZStack {
                BackgroundView()

                ForEach(0..<7, id: \.self) { index in
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: CGFloat(18 + index % 3 * 4)))
                        .foregroundStyle(.white.opacity(0.22))
                        .position(
                            x: CGFloat(index) * max(size.width / 6, 1) + 24,
                            y: 100 + CGFloat(index % 4) * 48
                        )
                }

                ground(at: groundY, in: size)

                ForEach(viewModel.obstacles) { obstacle in
                    ObstacleView(obstacle: obstacle)
                        .position(
                            x: obstacle.xPosition,
                            y: groundY - obstacle.size.height / 2
                        )
                }

                PlayerView(
                    character: viewModel.selectedCharacter,
                    state: viewModel.playerRunState,
                    rotationDegrees: viewModel.playerRotationDegrees
                )
                    .position(
                        x: viewModel.playerX,
                        y: groundY - viewModel.playerSize.height / 2 - viewModel.playerY
                    )

                VStack {
                    if viewModel.gameState == .playing {
                        HUDView(
                            score: viewModel.score,
                            highScore: viewModel.highScore,
                            character: viewModel.selectedCharacter,
                            onHome: viewModel.returnHome
                        )
                    }
                    Spacer()
                }

                if viewModel.gameState == .home {
                    HomeOverlayView(
                        highScore: viewModel.highScore,
                        onEnter: viewModel.showCharacterSelection
                    )
                }

                if viewModel.gameState == .characterSelection {
                    CharacterSelectionOverlayView(
                        selectedCharacter: viewModel.selectedCharacter,
                        onSelect: viewModel.selectCharacter,
                        onStart: { viewModel.startGame(playAreaSize: size) },
                        onBack: viewModel.returnHome
                    )
                }

                if viewModel.gameState == .gameOver {
                    Color.black.opacity(0.12)
                        .ignoresSafeArea()

                    GameOverView(
                        score: viewModel.score,
                        highScore: viewModel.highScore,
                        character: viewModel.selectedCharacter,
                        onRestart: viewModel.restartGame,
                        onHome: viewModel.returnToCharacterSelection
                    )
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.jump()
            }
            .onAppear {
                viewModel.configure(playAreaSize: size)
            }
            .onChange(of: size) { _, newSize in
                viewModel.configure(playAreaSize: newSize)
            }
        }
    }

    private func ground(at groundY: CGFloat, in size: CGSize) -> some View {
        let groundHeight = max(size.height - groundY, 0) + 80

        return ZStack(alignment: .top) {
            Rectangle()
                .fill(Color(red: 0.40, green: 0.72, blue: 0.36))

            HStack(spacing: 14) {
                ForEach(0..<18, id: \.self) { index in
                    Capsule()
                        .fill(index.isMultiple(of: 2) ? Color.white.opacity(0.35) : Color.yellow.opacity(0.32))
                        .frame(width: 26, height: 8)
                }
            }
            .padding(.top, 12)
        }
        .frame(width: size.width, height: groundHeight)
        .position(x: size.width / 2, y: groundY + groundHeight / 2)
        .ignoresSafeArea(edges: .bottom)
    }
}

private struct BackgroundView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.56, green: 0.84, blue: 1.0),
                        Color(red: 0.88, green: 0.96, blue: 1.0),
                        Color(red: 0.74, green: 0.90, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                SunView()
                    .frame(width: 86, height: 86)
                    .position(x: size.width - 64, y: 84)

                CloudView(scale: 1.0)
                    .position(x: size.width * 0.24, y: 92)

                CloudView(scale: 0.78)
                    .position(x: size.width * 0.62, y: 145)

                CloudView(scale: 0.58)
                    .position(x: size.width * 0.86, y: 210)
            }
            .ignoresSafeArea()
        }
    }
}

private struct SunView: View {
    var body: some View {
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                Capsule()
                    .fill(Color.yellow.opacity(0.42))
                    .frame(width: 7, height: 22)
                    .offset(y: -50)
                    .rotationEffect(.degrees(Double(index) * 36))
            }

            Circle()
                .fill(Color(red: 1.0, green: 0.78, blue: 0.22))
                .overlay(
                    Circle()
                        .fill(Color.white.opacity(0.22))
                        .padding(12)
                )
        }
    }
}

private struct CloudView: View {
    let scale: CGFloat

    var body: some View {
        ZStack {
            Capsule()
                .fill(.white.opacity(0.82))
                .frame(width: 112, height: 34)
                .offset(y: 14)

            Circle()
                .fill(.white.opacity(0.9))
                .frame(width: 46, height: 46)
                .offset(x: -34, y: 2)

            Circle()
                .fill(.white.opacity(0.94))
                .frame(width: 62, height: 62)
                .offset(x: 0, y: -8)

            Circle()
                .fill(.white.opacity(0.88))
                .frame(width: 44, height: 44)
                .offset(x: 36, y: 4)
        }
        .scaleEffect(scale)
        .frame(width: 128 * scale, height: 78 * scale)
    }
}

private struct HomeOverlayView: View {
    let highScore: Int
    let onEnter: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Text("🐾")
                .font(.system(size: 54))

            Text("毛孩跑跑隊")
                .font(.system(size: 38, weight: .heavy, design: .rounded))
                .foregroundStyle(.brown)

            Label("最高分 \(highScore)", systemImage: "crown.fill")
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundStyle(.orange)

            Button(action: onEnter) {
                Label("進入遊戲", systemImage: "pawprint.fill")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .frame(width: 210, height: 50)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
        .padding(24)
        .frame(maxWidth: 390)
        .background(.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.16), radius: 18, x: 0, y: 10)
        .padding(24)
    }
}

private struct CharacterSelectionOverlayView: View {
    let selectedCharacter: PlayerCharacter
    let onSelect: (PlayerCharacter) -> Void
    let onStart: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Text("選一位小夥伴")
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(.brown)

            Text("避開滿地寵物用品，跑出今日最萌紀錄！")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 14) {
                ForEach(PlayerCharacter.allCases) { character in
                    Button {
                        onSelect(character)
                    } label: {
                        VStack(spacing: 8) {
                            Text(character.emoji)
                                .font(.system(size: 44))

                            Text(character.name)
                                .font(.system(size: 15, weight: .heavy, design: .rounded))
                                .lineLimit(1)
                        }
                        .frame(width: 118, height: 116)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedCharacter == character ? character.bodyColor.opacity(0.9) : .white.opacity(0.82))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selectedCharacter == character ? character.accentColor : .white, lineWidth: 3)
                        )
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.brown)
                }
            }

            HStack(spacing: 12) {
                Button(action: onBack) {
                    Label("返回", systemImage: "chevron.left")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.brown)

                Button(action: onStart) {
                    Label("開始跑跑", systemImage: "play.fill")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
        }
        .padding(24)
        .frame(maxWidth: 390)
        .background(.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.16), radius: 18, x: 0, y: 10)
        .padding(24)
    }
}

#Preview {
    GameView(viewModel: GameViewModel())
}
