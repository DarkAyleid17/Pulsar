import Foundation

#if os(Windows)
import WinSDK
#elseif os(Linux)
import Glibc
#endif

@main
struct PulsarGame {
    static func main() async {
        print("🎮 Pulsar - Retro Pong Game")
        print("================================")
        print("Player 1: W/S keys")
        print("Player 2: ↑/↓ arrow keys")
        print("Press 'q' to quit")
        print("Press any key to start...")
        
        let platform = Platform.current
        _ = platform.getChar()
        
        let game = Game()
        await game.run()
    }
}
