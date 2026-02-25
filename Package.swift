// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Claufication",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Claufication",
            path: "Sources/Claufication"
        )
    ]
)
