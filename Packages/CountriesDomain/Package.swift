// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CountriesDomain",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CountriesDomain", targets: ["CountriesDomain"]),
    ],
    targets: [
        .target(name: "CountriesDomain"),
    ]
)
