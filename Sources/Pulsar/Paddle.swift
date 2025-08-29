import Foundation

actor Paddle {
    private var x: Int
    private var y: Int
    private let paddleHeight: Int
    private let speed: Int = 1
    
    init(x: Int, y: Int, height: Int) {
        self.x = x
        self.y = y
        self.paddleHeight = height
    }
    
    func moveUp() {
        y -= speed
    }
    
    func moveDown() {
        y += speed
    }
    
    func constrainToBounds(minY: Int, maxY: Int) {
        let halfHeight = paddleHeight / 2
        if y - halfHeight < minY {
            y = minY + halfHeight
        } else if y + halfHeight > maxY {
            y = maxY - halfHeight
        }
    }
    
    func getPosition() -> (x: Int, y: Int) {
        return (x: x, y: y)
    }
}
