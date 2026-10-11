// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CountriesUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CountriesUI", targets: ["CountriesUI"]),
    ],
    dependencies: [
        .package(path: "../CountriesDomain"),
    ],
    targets: [
        .target(name: "CountriesUI", dependencies: ["CountriesDomain"]),
        .testTarget(name: "CountriesUITests", dependencies: ["CountriesUI"]),
    ]
)
