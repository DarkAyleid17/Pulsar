cmake_minimum_required(VERSION 4.0.0)
project(Pulsar LANGUAGES Swift)

# Set Swift compiler flags for Swift 6.1
set(CMAKE_Swift_LANGUAGE_VERSION 6)
set(CMAKE_Swift_FLAGS "-swift-version 6")

# Platform-specific configurations
if(WIN32)
    set(CMAKE_Swift_FLAGS "${CMAKE_Swift_FLAGS} -D WINDOWS")
    # Windows-specific Swift flags
    set(CMAKE_Swift_FLAGS "${CMAKE_Swift_FLAGS} -Xlinker /SUBSYSTEM:CONSOLE")
elseif(UNIX AND NOT APPLE)
    set(CMAKE_Swift_FLAGS "${CMAKE_Swift_FLAGS} -D LINUX")
    # Linux-specific configurations
    find_package(PkgConfig REQUIRED)
endif()

# Add executable
add_executable(Pulsar
    Sources/Pulsar/main.swift
    Sources/Pulsar/Game.swift
    Sources/Pulsar/Paddle.swift
    Sources/Pulsar/Ball.swift
    Sources/Pulsar/GameRenderer.swift
    Sources/Pulsar/Platform/Platform.swift
    Sources/Pulsar/Platform/LinuxPlatform.swift
    Sources/Pulsar/Platform/WindowsPlatform.swift
)

# Set output directory
set_target_properties(Pulsar PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

# Installation
install(TARGETS Pulsar DESTINATION bin)
