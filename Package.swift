// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "ExtSwift",
    platforms: [
        // get supported min versions by setting `swift-tools-version:5.9`
        .iOS(.v15),
        // .tvOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "ExtSwift", targets: ["ExtSwift"]),
        // .library(name: "ExtSwift-Static", type: .static, targets: ["ExtSwift"]),
        .library(name: "ExtSwift-Dynamic", type: .dynamic, targets: ["ExtSwift"])
    ],
    dependencies: [
        // .package(url: "https://github.com/swiftlang/swift-docc-plugin", branch: "main"),
        // .package(url: "https://github.com/iwill/ExCodable", branch: "develop"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "ExtSwift",
            dependencies: [
                // "ExCodable",
                "SnapKit"
            ]
        ),
        .testTarget(
            name: "ExtSwiftTests",
            dependencies: [
                "ExtSwift"
            ])
    ],
    swiftLanguageModes: [.v6]
)
