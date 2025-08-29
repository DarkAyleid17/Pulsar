import Foundation

actor Game {
    private let width: Int = 80
    private let height: Int = 24
    private let targetFPS: Double = 60.0
    
    private var player1: Paddle
    private var player2: Paddle
    private var ball: Ball
    private var renderer: GameRenderer
    private var platform: any PlatformProtocol
    
    private var player1Score: Int = 0
    private var player2Score: Int = 0
    private var isRunning: Bool = true
    
    init() {
        self.platform = Platform.current
        self.player1 = Paddle(x: 2, y: height / 2, height: 6)
        self.player2 = Paddle(x: width - 3, y: height / 2, height: 6)
        self.ball = Ball(x: width / 2, y: height / 2, dx: 1, dy: 1)
        self.renderer = GameRenderer(width: width, height: height)
    }
    
    func run() async {
        let frameTime = 1.0 / targetFPS
        
        while isRunning {
            let startTime = platform.getCurrentTime()
            
            await handleInput()
            await update()
            await render()
            
            let elapsedTime = platform.getCurrentTime() - startTime
            let sleepTime = frameTime - elapsedTime
            
            if sleepTime > 0 {
                await platform.sleep(duration: sleepTime)
            }
        }
        
        platform.clearScreen()
        print("Thanks for playing Pulsar! 🎮")
    }
    
    private func handleInput() async {
        let input = platform.getInputNonBlocking()
        
        switch input {
        case "w", "W":
            await player1.moveUp()
        case "s", "S":
            await player1.moveDown()
        case "\u{1B}[A": // Up arrow
            await player2.moveUp()
        case "\u{1B}[B": // Down arrow
            await player2.moveDown()
        case "q", "Q":
            isRunning = false
        default:
            break
        }
    }
    
    private func update() async {
        // Update ball position
        await ball.update()
        
        // Keep paddles within bounds
        await player1.constrainToBounds(minY: 1, maxY: height - 2)
        await player2.constrainToBounds(minY: 1, maxY: height - 2)
        
        // Ball collision with top and bottom walls
        let ballPos = await ball.getPosition()
        if ballPos.y <= 0 || ballPos.y >= height - 1 {
            await ball.reverseVertical()
        }
        
        // Ball collision with paddles
        let player1Pos = await player1.getPosition()
        let player2Pos = await player2.getPosition()
        
        if await ball.checkCollision(with: player1Pos, paddleHeight: 6) {
            await ball.reverseHorizontal()
            await ball.setPosition(x: player1Pos.x + 2, y: ballPos.y)
        }
        
        if await ball.checkCollision(with: player2Pos, paddleHeight: 6) {
            await ball.reverseHorizontal()
            await ball.setPosition(x: player2Pos.x - 1, y: ballPos.y)
        }
        
        // Scoring
        if ballPos.x <= 0 {
            player2Score += 1
            await resetBall()
        } else if ballPos.x >= width - 1 {
            player1Score += 1
            await resetBall()
        }
    }
    
    private func resetBall() async {
        await ball.setPosition(x: width / 2, y: height / 2)
        await ball.setVelocity(dx: [-1, 1].randomElement()!, dy: [-1, 1].randomElement()!)
    }
    
    private func render() async {
        platform.clearScreen()
        
        let player1Pos = await player1.getPosition()
        let player2Pos = await player2.getPosition()
        let ballPos = await ball.getPosition()
        
        await renderer.clear()
        await renderer.drawPaddle(at: player1Pos, height: 6)
        await renderer.drawPaddle(at: player2Pos, height: 6)
        await renderer.drawBall(at: ballPos)
        await renderer.drawScore(player1: player1Score, player2: player2Score, width: width)
        await renderer.display(platform: platform)
    }
}
