// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LanguageLearning",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "LanguageLearning",
      targets: ["Assessing", "Learning"]),
  ],
  dependencies: [
    .package(path: "../Languages")
  ],
  targets: [
    .target(
      name: "Assessing",
      dependencies: ["Learning"]),
    .target(
      name: "Learning",
      dependencies: ["Languages"]),
    .testTarget(
      name: "LearningTests",
      dependencies: ["Learning"]),
  ]
)
