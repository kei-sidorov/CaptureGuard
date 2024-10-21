// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CaptureGuard",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "CaptureGuard", targets: ["CaptureGuard"]),
        .library(name: "CaptureGuardUIKit", targets: ["CaptureGuardUIKit"])
    ],
    targets: [
        .target(name: "CaptureGuard", dependencies: []),
        .target(name: "CaptureGuardUIKit", dependencies: ["CaptureGuard"])
    ]
)