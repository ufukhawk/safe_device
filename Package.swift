// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "safe_device",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "safe_device",
            targets: ["safe_device"]
        )
    ],
    targets: [
        .target(
            name: "safe_device",
            path: "ios",
            sources: ["Classes"],
            publicHeadersPath: "Classes"
        )
    ]
)
