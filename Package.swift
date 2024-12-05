// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AiSDK",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AiSDK",
            targets: ["AiSDK"]),
    ],
    dependencies: [
        ///网络库
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.0")),
        ///解析库
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AiSDK",
            dependencies: ["Alamofire","SwiftyJSON"]),
        .testTarget(
            name: "AiSDKTests",
            dependencies: ["AiSDK"]),
    ]
)
