// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "JsonScripts",
  dependencies: [
    // Dev dependencies
    .package(url: "https://github.com/apple/swift-format.git", branch: ("release/5.10"))
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "JsonScripts")
  ]
)
