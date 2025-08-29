import Foundation

#if os(Windows)
import CRT
#elseif os(Linux)
import Glibc
#endif

// Remove @main and use top-level code instead
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