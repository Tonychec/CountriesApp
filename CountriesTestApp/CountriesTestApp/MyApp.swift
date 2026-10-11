import CountriesData
import CountriesUI
import SwiftUI

/// Composition root: the only place that knows the concrete repository.
@main struct MyApp: App {
    private let repository = ApolloCountriesRepository.live(url: URL(string: "https://countries.trevorblades.com/")!)

    var body: some Scene {
        WindowGroup {
            CountryListScreen()
                .environment(\.countriesRepository, repository)
        }
    }
}
