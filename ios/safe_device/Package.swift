// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "safe_device",
    platforms: [
        // Bumped from the podspec's historical 9.0 floor — Flutter SPM requires iOS 12+.
        .iOS("12.0")
    ],
    products: [
        .library(name: "safe-device", targets: ["safe_device"])
    ],
    dependencies: [
        .package(url: "https://github.com/thii/DTTJailbreakDetection.git", from: "0.4.0")
    ],
    targets: [
        .target(
            name: "safe_device",
            dependencies: [
                .product(name: "DTTJailbreakDetection", package: "DTTJailbreakDetection")
            ],
            // Implementation (.m) files live in Sources/safe_device/, public headers
            // (.h) in Sources/safe_device/include/safe_device/. The header search path
            // lets the .m files resolve their sibling headers by bare name.
            cSettings: [
                .headerSearchPath("include/safe_device")
            ]
        )
    ]
)
