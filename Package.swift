// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExtSwift",
    platforms: [
        .iOS(.v10),
        .macOS(.v11),
        // .tvOS(.v10),
    ],
    products: [
        .library(
            name: "ExtSwift",
            targets: ["ExtSwift"]),
    ],
    dependencies: [
        // .package(url: "https://github.com/user/repo", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "ExtSwift",
            dependencies: []),
        .testTarget(
            name: "ExtSwiftTests",
            dependencies: ["ExtSwift"]),
    ]
)
