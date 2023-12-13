// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "ExtSwift",
    platforms: [
        // supported min versions for `swift-tools-version:5.9`
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v10_13),
        .watchOS(.v4)
    ],
    products: [
        .library(name: "ExtSwift", targets: ["ExtSwift"]),
        .library(name: "ExtSwift-Static", type: .static, targets: ["ExtSwift"]),
        .library(name: "ExtSwift-Dynamic", type: .dynamic, targets: ["ExtSwift"])
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
