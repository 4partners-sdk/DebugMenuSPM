// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DebugMenuSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "DebugMenuSDK", targets: ["DebugMenuSDK"])
    ],
    targets: [
        .target(
            name: "DebugMenuSDK",
            dependencies: []
        ),
        .testTarget(
            name: "DebugMenuSDKTests",
            dependencies: ["DebugMenuSDK"]
        )
    ]
)
