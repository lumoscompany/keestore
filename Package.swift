// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Keestore",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
    ],
    products: [
        .library(name: "Keestore", targets: ["Keestore"]),
        .library(name: "BIP", targets: ["BIP"]),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.3.0"),
        .package(url: "https://github.com/lumoscompany/libkeccak.swift", from: "0.1.0"),
        .package(url: "https://github.com/lumoscompany/libsecp256k1.swift", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "Keestore",
            dependencies: ["BIP"],
            path: "Sources/Keestore",
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "BIP",
            dependencies: ["ObscureKit", "BigInt"],
            path: "Sources/BIP",
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "ObscureKit",
            dependencies: [
                .product(name: "libsecp256k1", package: "libsecp256k1.swift"),
                .product(name: "libkeccak", package: "libkeccak.swift"),
                "BigInt",
            ],
            path: "Sources/ObscureKit",
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .testTarget(
            name: "BIPTests",
            dependencies: ["BIP", "ObscureKit"]
        ),
        .testTarget(
            name: "KeestoreTests",
            dependencies: ["Keestore"]
        ),
        .testTarget(
            name: "ObscureKitTests",
            dependencies: ["ObscureKit"]
        ),
    ]
)
