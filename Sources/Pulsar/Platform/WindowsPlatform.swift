import Foundation

#if os(Windows)
import WinSDK

struct WindowsPlatform: PlatformProtocol {
    private let consoleHandle: HANDLE
    private var originalConsoleMode: DWORD = 0
    
    init() {
        consoleHandle = GetStdHandle(STD_OUTPUT_HANDLE)
        
        // Get current console mode
        GetConsoleMode(GetStdHandle(STD_INPUT_HANDLE), &originalConsoleMode)
        
        // Set console mode for immediate key detection
        let inputHandle = GetStdHandle(STD_INPUT_HANDLE)
        var mode: DWORD = 0
        GetConsoleMode(inputHandle, &mode)
        mode &= ~DWORD(ENABLE_LINE_INPUT | ENABLE_ECHO_INPUT)
        mode |= DWORD(ENABLE_PROCESSED_INPUT)
        SetConsoleMode(inputHandle, mode)
        
        // Hide cursor
        var cursorInfo = CONSOLE_CURSOR_INFO()
        GetConsoleCursorInfo(consoleHandle, &cursorInfo)
        cursorInfo.bVisible = FALSE
        SetConsoleCursorInfo(consoleHandle, &cursorInfo)
    }
    
    func clearScreen() {
        let command = "cls"
        _ = system(command)
    }
    
    func setCursorPosition(x: Int, y: Int) {
        var coord = COORD()
        coord.X = SHORT(x)
        coord.Y = SHORT(y)
        SetConsoleCursorPosition(consoleHandle, coord)
    }
    
    func getChar() -> String {
        let char = _getch()
        return String(Character(UnicodeScalar(Int(char))!))
    }
    
    func getInputNonBlocking() -> String? {
        if _kbhit() != 0 {
            let char = _getch()
            
            // Handle special keys
            if char == 224 { // Extended key prefix
                let extendedChar = _getch()
                switch extendedChar {
                case 72: return "\u{001B}[A" // Up arrow
                case 80: return "\u{001B}[B" // Down arrow
                case 77: return "\u{001B}[C" // Right arrow
                case 75: return "\u{001B}[D" // Left arrow
                default: break
                }
            }
            
            return String(Character(UnicodeScalar(Int(char))!))
        }
        return nil
    }
    
    func print(_ text: String) {
        Swift.print(text, terminator: "")
    }
    
    func getCurrentTime() -> Double {
        var frequency: LARGE_INTEGER = LARGE_INTEGER()
        var counter: LARGE_INTEGER = LARGE_INTEGER()
        
        QueryPerformanceFrequency(&frequency)
        QueryPerformanceCounter(&counter)
        
        return Double(counter.QuadPart) / Double(frequency.QuadPart)
    }
    
    func sleep(duration: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }
    
    deinit {
        // Restore console mode
        let inputHandle = GetStdHandle(STD_INPUT_HANDLE)
        SetConsoleMode(inputHandle, originalConsoleMode)
        
        // Show cursor
        var cursorInfo = CONSOLE_CURSOR_INFO()
        GetConsoleCursorInfo(consoleHandle, &cursorInfo)
        cursorInfo.bVisible = TRUE
        SetConsoleCursorInfo(consoleHandle, &cursorInfo)
    }
}
#endif
