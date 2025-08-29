// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pulsar",
    products: [
        .executable(
            name: "Pulsar",
            targets: ["Pulsar"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "Pulsar",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
    ]
)