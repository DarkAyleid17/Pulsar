import Foundation

actor GameRenderer {
    private let width: Int
    private let height: Int
    private var screen: [[Character]]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.screen = Array(repeating: Array(repeating: " ", count: width), count: height)
    }
    
    func clear() {
        for y in 0..<height {
            for x in 0..<width {
                screen[y][x] = " "
            }
        }
        
        // Draw borders
        for x in 0..<width {
            screen[0][x] = "─"
            screen[height - 1][x] = "─"
        }
        
        // Draw center line
        for y in 0..<height {
            if y % 2 == 0 {
                screen[y][width / 2] = "┊"
            }
        }
    }
    
    func drawPaddle(at position: (x: Int, y: Int), height paddleHeight: Int) {
        let halfHeight = paddleHeight / 2
        let startY = max(1, position.y - halfHeight)
        let endY = min(self.height - 2, position.y + halfHeight)
        
        for y in startY...endY {
            if position.x >= 0 && position.x < width && y >= 0 && y < height {
                screen[y][position.x] = "█"
            }
        }
    }
    
    func drawBall(at position: (x: Int, y: Int)) {
        if position.x >= 0 && position.x < width && 
           position.y >= 0 && position.y < height {
            screen[position.y][position.x] = "●"
        }
    }
    
    func drawScore(player1: Int, player2: Int, width: Int) {
        let scoreText = "\(player1)   \(player2)"
        let startX = (width - scoreText.count) / 2
        
        if startX >= 0 {
            for (index, char) in scoreText.enumerated() {
                let x = startX + index
                if x < width {
                    screen[1][x] = char
                }
            }
        }
    }
    
    func display(platform: any PlatformProtocol) {
        var output = ""
        for y in 0..<height {
            for x in 0..<width {
                output += String(screen[y][x])
            }
            output += "\n"
        }
        
        platform.setCursorPosition(x: 0, y: 0)
        platform.print(output)
    }
}
