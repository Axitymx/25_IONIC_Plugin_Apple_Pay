// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorApplepay",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapacitorApplepay",
            targets: ["ApplePaySessionPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "ApplePaySessionPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/ApplePaySessionPlugin"),
        .testTarget(
            name: "ApplePaySessionPluginTests",
            dependencies: ["ApplePaySessionPlugin"],
            path: "ios/Tests/ApplePaySessionPluginTests")
    ]
)
