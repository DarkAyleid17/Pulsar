// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pulsar",
    platforms: [
        .macOS(.v10_15),
        .linux,
    ],
    products: [
        .executable(
            name: "Pulsar",
            targets: ["Pulsar"]
        ),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Pulsar",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImportObjcForwardDeclarations"),
                .enableUpcomingFeature("DisableOutwardActorInference"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("DeprecateApplicationMain"),
                .enableUpcomingFeature("IsolatedDefaultValues"),
                .enableUpcomingFeature("GlobalConcurrency")
            ]
        ),
    ]
)
