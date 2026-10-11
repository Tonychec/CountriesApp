// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CountriesData",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CountriesData", targets: ["CountriesData"]),
    ],
    dependencies: [
        .package(path: "../CountriesDomain"),
    ],
    targets: [
        .target(name: "CountriesData", dependencies: ["CountriesDomain"]),
        .testTarget(name: "CountriesDataTests", dependencies: ["CountriesData"]),
    ]
)
