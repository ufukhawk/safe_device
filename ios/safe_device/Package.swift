// swift-tools-version:5.7
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
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "safe_device",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "../Classes",
            publicHeadersPath: "."
        )
    ]
)
