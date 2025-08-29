import Foundation

actor Ball {
    private var x: Int
    private var y: Int
    private var dx: Int
    private var dy: Int
    
    init(x: Int, y: Int, dx: Int, dy: Int) {
        self.x = x
        self.y = y
        self.dx = dx
        self.dy = dy
    }
    
    func update() {
        x += dx
        y += dy
    }
    
    func reverseHorizontal() {
        dx = -dx
    }
    
    func reverseVertical() {
        dy = -dy
    }
    
    func getPosition() -> (x: Int, y: Int) {
        return (x: x, y: y)
    }
    
    func setPosition(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func setVelocity(dx: Int, dy: Int) {
        self.dx = dx
        self.dy = dy
    }
    
    func checkCollision(with paddlePos: (x: Int, y: Int), paddleHeight: Int) -> Bool {
        let halfHeight = paddleHeight / 2
        return x == paddlePos.x && 
               y >= paddlePos.y - halfHeight && 
               y <= paddlePos.y + halfHeight
    }
}
