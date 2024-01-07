// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "ExtSwift",
    platforms: [
        // ge supported min versions from `swift-tools-version:5.9`
        .iOS(.v15),
        .tvOS(.v15)
        // .macOS(.v12)
    ],
    products: [
        .library(name: "ExtSwift", targets: ["ExtSwift"]),
        // .library(name: "ExtSwift-Static", type: .static, targets: ["ExtSwift"]),
        .library(name: "ExtSwift-Dynamic", type: .dynamic, targets: ["ExtSwift"])
    ],
    dependencies: [
        // .package(url: "https://github.com/iwill/ExCodable", branch: "develop"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0")
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
    swiftLanguageVersions: [.v5]
)
