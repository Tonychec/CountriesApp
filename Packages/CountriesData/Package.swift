// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CountriesData",
    platforms: [.iOS(.v17)],
    products: [
        // CountriesAPI is deliberately not a product, so generated code never leaves this package.
        .library(name: "CountriesData", targets: ["CountriesData"]),
    ],
    dependencies: [
        .package(path: "../CountriesDomain"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "2.4.0"),
    ],
    targets: [
        .target(
            name: "CountriesAPI",
            dependencies: [.product(name: "ApolloAPI", package: "apollo-ios")]
        ),
        .target(
            name: "CountriesData",
            dependencies: [
                "CountriesDomain",
                "CountriesAPI",
                .product(name: "Apollo", package: "apollo-ios"),
            ]
        ),
        .testTarget(
            name: "CountriesDataTests",
            dependencies: [
                "CountriesData",
                "CountriesDomain",
                "CountriesAPI",
                // Builds generated data from JSON fixtures.
                .product(name: "Apollo", package: "apollo-ios"),
            ],
            resources: [.copy("Fixtures")]
        ),
    ]
)
