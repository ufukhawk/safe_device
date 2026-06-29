// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// DTTJailbreakDetection is vendored into Sources/DTTJailbreakDetection/ instead of
// pulled from https://github.com/thii/DTTJailbreakDetection.git, because that upstream
// repository ships no Package.swift (it is a CocoaPods-only pod). Referencing it as a
// remote SwiftPM dependency made resolution fail with
// "the package manifest at '/Package.swift' cannot be accessed". The vendored copy is
// the 0.4.0 source, byte-for-byte identical to the pod's Classes/.
let package = Package(
    name: "safe_device",
    platforms: [
        // Bumped from the podspec's historical 9.0 floor — Flutter SPM requires iOS 12+.
        .iOS("12.0")
    ],
    products: [
        .library(name: "safe-device", targets: ["safe_device"]),
        // Expose DTT as a product too, so consumers that reference it explicitly still link.
        .library(name: "DTTJailbreakDetection", targets: ["DTTJailbreakDetection"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DTTJailbreakDetection",
            path: "Sources/DTTJailbreakDetection",
            publicHeadersPath: "include/DTTJailbreakDetection"
        ),
        .target(
            name: "safe_device",
            dependencies: [
                "DTTJailbreakDetection"
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
