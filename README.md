# Project Structure
Pulsar/
├── Package.swift
├── CMakeLists.txt
├── Sources/
│   └── Pulsar/
│       ├── main.swift
│       ├── Game.swift
│       ├── Paddle.swift
│       ├── Ball.swift
│       ├── GameRenderer.swift
│       └── Platform/
│           ├── Platform.swift
│           ├── LinuxPlatform.swift
│           └── WindowsPlatform.swift
└── README.md


# Build Instructions
Prerequisites

Swift 6.1 or later
CMake 3.29 or later
Platform-specific build tools
# Building on Linux:
## Using Swift Package Manager
swift build -c release

## Or using CMake
mkdir build && cd build
cmake ..
make

# Building on Windows:
## Using Swift Package Manager (requires Swift for Windows)
swift build -c release

## Or using CMake with Visual Studio
mkdir build && cd build
cmake .. -G "Visual Studio 17 2022"
cmake --build . --config Release


# Key Features of the Swift Rewrite:
- Swift 6.1 Compatibility: Uses the latest Swift 6 features including actor isolation and structured concurrency
- Cross-Platform: Platform abstraction layer supports Linux, Windows, and macOS
- Modern Architecture: Uses actors for thread-safe game state management
- Async/Await: Leverages Swift's modern concurrency features
- Type Safety: Full type safety with Swift's strong type system
- Memory Safe: No manual memory management needed
- CMake Support: Modern CMake 4.1.1+ configuration for cross-platform builds

The game maintains the original retro aesthetic and gameplay while providing a modern, safe, and maintainable Swift implementation that can run on multiple platforms.
