import Foundation

#if os(Linux)
import Glibc

struct LinuxPlatform: PlatformProtocol {
    private let stdin = FileHandle.standardInput
    
    init() {
        // Set terminal to raw mode for immediate key detection
        system("stty cbreak -echo")
        
        // Hide cursor for cleaner display
        Swift.print("\u{001B}[?25l", terminator: "")
        fflush(stdout)
    }
    
    func clearScreen() {
        Swift.print("\u{001B}[2J", terminator: "")
        fflush(stdout)
    }
    
    func setCursorPosition(x: Int, y: Int) {
        Swift.print("\u{001B}[\(y + 1);\(x + 1)H", terminator: "")
        fflush(stdout)
    }
    
    func getChar() -> String {
        let char = getchar()
        return String(Character(UnicodeScalar(char)!))
    }
    
    func getInputNonBlocking() -> String? {
        // Set stdin to non-blocking mode
        let flags = fcntl(STDIN_FILENO, F_GETFL, 0)
        fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK)
        
        let char = getchar()
        
        // Reset stdin to blocking mode
        fcntl(STDIN_FILENO, F_SETFL, flags)
        
        if char == EOF {
            return nil
        }
        
        // Handle escape sequences for arrow keys
        if char == 27 { // ESC
            let char2 = getchar()
            if char2 == 91 { // [
                let char3 = getchar()
                switch char3 {
                case 65: return "\u{001B}[A" // Up
                case 66: return "\u{001B}[B" // Down
                case 67: return "\u{001B}[C" // Right
                case 68: return "\u{001B}[D" // Left
                default: break
                }
            }
        }
        
        return String(Character(UnicodeScalar(char)!))
    }
    
    func print(_ text: String) {
        Swift.print(text, terminator: "")
        fflush(stdout)
    }
    
    func getCurrentTime() -> Double {
        var timespec = timespec()
        clock_gettime(CLOCK_MONOTONIC, &timespec)
        return Double(timespec.tv_sec) + Double(timespec.tv_nsec) / 1_000_000_000.0
    }
    
    func sleep(duration: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }
    
    deinit {
        // Restore terminal settings
        system("stty sane")
        Swift.print("\u{001B}[?25h") // Show cursor
    }
}
#else
// Fallback for non-Linux platforms
struct LinuxPlatform: PlatformProtocol {
    func clearScreen() {}
    func setCursorPosition(x: Int, y: Int) {}
    func getChar() -> String { return "" }
    func getInputNonBlocking() -> String? { return nil }
    func print(_ text: String) {}
    func getCurrentTime() -> Double { return 0 }
    func sleep(duration: Double) async {}
}
#endif