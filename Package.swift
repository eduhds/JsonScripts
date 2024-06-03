// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "JsonScripts",
  dependencies: [
    .package(url: "https://github.com/apple/example-package-figlet", branch: "main"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    .package(url: "https://github.com/jordanbaird/Prism", from: "0.1.2"),
    // Dev dependencies
    .package(url: "https://github.com/apple/swift-format.git", branch: ("release/5.10")),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "JsonScripts",
      dependencies: [
        .product(name: "Figlet", package: "example-package-figlet"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Prism", package: "Prism"),
      ],
      path: "Sources")
  ]
)
