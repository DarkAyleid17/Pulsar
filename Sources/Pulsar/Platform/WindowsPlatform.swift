import Foundation

#if os(Windows)
import CRT

struct WindowsPlatform: PlatformProtocol {
    
    init() {
        // Enable ANSI escape sequences on Windows 10+
        _ = system("chcp 65001 > nul 2>&1")
    }
    
    func clearScreen() {
        _ = system("cls")
        Swift.print("\u{001B}[?25l", terminator: "") // Hide cursor - use Swift.print explicitly
        fflush(stdout)
    }
    
    func setCursorPosition(x: Int, y: Int) {
        Swift.print("\u{001B}[\(y + 1);\(x + 1)H", terminator: "")
        fflush(stdout)
    }
    
    func getChar() -> String {
        let char = _getch()
        return String(Character(UnicodeScalar(Int(char))!))
    }
    
    func getInputNonBlocking() -> String? {
        if _kbhit() != 0 {
            let char = _getch()
            
            // Handle extended keys (arrow keys)
            if char == -32 { // Extended key prefix on Windows
                let extendedChar = _getch()
                switch extendedChar {
                case 72: return "\u{001B}[A" // Up arrow
                case 80: return "\u{001B}[B" // Down arrow
                case 75: return "\u{001B}[D" // Left arrow
                case 77: return "\u{001B}[C" // Right arrow
                default: break
                }
            }
            
            return String(Character(UnicodeScalar(Int(char))!))
        }
        return nil
    }
    
    func print(_ text: String) {
        Swift.print(text, terminator: "") // Use Swift.print explicitly
        fflush(stdout)
    }
    
    func getCurrentTime() -> Double {
        return Double(clock()) / Double(CLOCKS_PER_SEC)
    }
    
    func sleep(duration: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }
}
#else
// Fallback for non-Windows platforms
struct WindowsPlatform: PlatformProtocol {
    func clearScreen() {}
    func setCursorPosition(x: Int, y: Int) {}
    func getChar() -> String { return "" }
    func getInputNonBlocking() -> String? { return nil }
    func print(_ text: String) {}
    func getCurrentTime() -> Double { return 0 }
    func sleep(duration: Double) async {}
}
#endif