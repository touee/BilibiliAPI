// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BilibiliAPI",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "BilibiliAPI",
            targets: ["BilibiliAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/touee/swift-jq-wrapper.git", from: "0.0.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "BilibiliAPI",
            dependencies: ["Cryptor", "JQWrapper"]),
        .testTarget(
            name: "BilibiliAPITests",
            dependencies: ["BilibiliAPI"]),
    ]
)
