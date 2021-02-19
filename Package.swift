// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ExtSwift",
    platforms: [
        .iOS(.v10),
        .macOS(.v11)
        // , .tvOS(.v10)
    ],
    products: [
        .library(
            name: "ExtSwift",
            targets: ["ExtSwift"])
    ],
    dependencies: [
        // .package(url: "https://github.com/iwill/ExCodable", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "ExtSwift",
            dependencies: [] // "ExCodable"
        ),
        .testTarget(
            name: "ExtSwiftTests",
            dependencies: ["ExtSwift"]) // "ExCodable"
    ],
    swiftLanguageVersions: [.v5]
)
