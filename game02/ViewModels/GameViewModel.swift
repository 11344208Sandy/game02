import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class GameViewModel {
    var gameState: GameState = .home
    var selectedCharacter: PlayerCharacter = .cat
    var playerRunState: PlayerRunState = .running
    var obstacles: [Obstacle] = []
    var score: Int = 0
    var highScore: Int
    var playerY: CGFloat = 0
    var playerRotationDegrees: Double = 0

    let playerSize = CGSize(width: 70, height: 70)
    let playerX: CGFloat = 86

    @ObservationIgnored private var verticalVelocity: CGFloat = 0
    @ObservationIgnored private var elapsedTime: TimeInterval = 0
    @ObservationIgnored private var spawnCountdown: TimeInterval = 1.1
    @ObservationIgnored private var gameTask: Task<Void, Never>?
    @ObservationIgnored private var playAreaSize: CGSize = .zero

    private let gravity: CGFloat = 1700
    private let jumpVelocity: CGFloat = 680
    private let baseScrollSpeed: CGFloat = 245
    private let maxDeltaTime: TimeInterval = 1.0 / 30.0
    private let highScoreKey = "petRunnerHighScore"

    init() {
        highScore = UserDefaults.standard.integer(forKey: highScoreKey)
    }

    deinit {
        gameTask?.cancel()
    }

    func configure(playAreaSize: CGSize) {
        self.playAreaSize = playAreaSize
    }

    func showCharacterSelection() {
        guard gameState != .playing else { return }
        gameState = .characterSelection
        resetRound()
    }

    func selectCharacter(_ character: PlayerCharacter) {
        guard gameState != .playing else { return }
        selectedCharacter = character
    }

    func startGame(playAreaSize: CGSize) {
        configure(playAreaSize: playAreaSize)
        gameTask?.cancel()
        gameState = .playing
        playerRunState = .running
        obstacles = []
        score = 0
        playerY = 0
        playerRotationDegrees = 0
        verticalVelocity = 0
        elapsedTime = 0
        spawnCountdown = 0.8
        startLoop()
    }

    func restartGame() {
        startGame(playAreaSize: playAreaSize)
    }

    func jump() {
        guard gameState == .playing, playerY == 0 else { return }
        verticalVelocity = jumpVelocity
        playerRotationDegrees = 0
        playerRunState = .jumping
    }

    func returnHome() {
        gameTask?.cancel()
        gameState = .home
        resetRound()
    }

    func returnToCharacterSelection() {
        gameTask?.cancel()
        gameState = .characterSelection
        resetRound()
    }

    private func resetRound() {
        playerRunState = .running
        obstacles = []
        score = 0
        playerY = 0
        playerRotationDegrees = 0
        verticalVelocity = 0
        elapsedTime = 0
        spawnCountdown = 0.8
    }

    private func startLoop() {
        gameTask = Task { [weak self] in
            var lastFrame = Date()

            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(16))

                guard let self else { return }
                let now = Date()
                let deltaTime = min(now.timeIntervalSince(lastFrame), maxDeltaTime)
                lastFrame = now

                guard gameState == .playing else { return }
                update(deltaTime: deltaTime)
            }
        }
    }

    private func update(deltaTime: TimeInterval) {
        guard playAreaSize.width > 0, playAreaSize.height > 0 else { return }

        elapsedTime += deltaTime
        score = Int(elapsedTime * 10) + obstacles.filter(\.hasScored).count * 10

        updatePlayer(deltaTime: deltaTime)
        updateObstacles(deltaTime: deltaTime)
        spawnObstaclesIfNeeded(deltaTime: deltaTime)
        checkCollisions()
    }

    private func updatePlayer(deltaTime: TimeInterval) {
        guard playerY > 0 || verticalVelocity > 0 else {
            playerRunState = .running
            return
        }

        verticalVelocity -= gravity * CGFloat(deltaTime)
        playerY += verticalVelocity * CGFloat(deltaTime)

        if playerY <= 0 {
            playerY = 0
            verticalVelocity = 0
            playerRunState = .running
        } else {
            playerRotationDegrees += 720 * deltaTime
            playerRunState = .jumping
        }
    }

    private func updateObstacles(deltaTime: TimeInterval) {
        let speed = currentScrollSpeed
        let playerRightEdge = playerX + playerSize.width * 0.32

        for index in obstacles.indices {
            obstacles[index].xPosition -= speed * CGFloat(deltaTime)

            if !obstacles[index].hasScored && obstacles[index].xPosition < playerRightEdge {
                obstacles[index].hasScored = true
            }
        }

        obstacles.removeAll { obstacle in
            obstacle.xPosition < -obstacle.size.width
        }
    }

    private func spawnObstaclesIfNeeded(deltaTime: TimeInterval) {
        spawnCountdown -= deltaTime

        guard spawnCountdown <= 0 else { return }

        let kind = ObstacleKind.allCases.randomElement() ?? .yarnBall
        let startX = playAreaSize.width + kind.size.width
        obstacles.append(Obstacle(kind: kind, xPosition: startX, size: kind.size))

        spawnCountdown = Double.random(in: 0.9...1.55)
    }

    private func checkCollisions() {
        let playerRect = CGRect(
            x: playerX - playerSize.width * 0.28,
            y: -playerY - playerSize.height * 0.82,
            width: playerSize.width * 0.56,
            height: playerSize.height * 0.72
        )

        if obstacles.contains(where: { playerRect.intersects($0.collisionRect) }) {
            finishGame()
        }
    }

    private func finishGame() {
        gameState = .gameOver
        playerRunState = .hit
        updateHighScoreIfNeeded()
        gameTask?.cancel()
    }

    private func updateHighScoreIfNeeded() {
        guard score > highScore else { return }

        highScore = score
        UserDefaults.standard.set(highScore, forKey: highScoreKey)
    }

    private var currentScrollSpeed: CGFloat {
        baseScrollSpeed + CGFloat(Int(elapsedTime / 15)) * 28
    }
}
