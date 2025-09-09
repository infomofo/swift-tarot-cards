// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTarotCards",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftTarotCards",
            targets: ["SwiftTarotCards"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.6"),
    ],
    targets: [
        .target(
            name: "SwiftTarotCards",
            dependencies: ["Yams"],
            resources: [
                .copy("Resources")
            ]
        ),
        .testTarget(
            name: "SwiftTarotCardsTests",
            dependencies: ["SwiftTarotCards"]),
    ]
)