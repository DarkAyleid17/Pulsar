import Foundation

#if os(Windows)
import WinSDK
#elseif os(Linux)
import Glibc
#endif

protocol PlatformProtocol: Sendable {
    func clearScreen()
    func setCursorPosition(x: Int, y: Int)
    func getChar() -> String
    func getInputNonBlocking() -> String?
    func print(_ text: String)
    func getCurrentTime() -> Double
    func sleep(duration: Double) async
}

struct Platform {
    static let current: any PlatformProtocol = {
        #if os(Windows)
        return WindowsPlatform()
        #elseif os(Linux)
        return LinuxPlatform()
        #else
        return LinuxPlatform() // Fallback
        #endif
    }()
}
