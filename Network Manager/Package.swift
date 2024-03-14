// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network Manager",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Network Manager",
            targets: ["Network Manager"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Network Manager",
            linkerSettings: [
                .linkedFramework("Foundation")
            ]
        ),
        .testTarget(
            name: "Network ManagerTests",
            dependencies: ["Network Manager"]),
    ],
    swiftLanguageVersions: [.version("5.7")]
)
