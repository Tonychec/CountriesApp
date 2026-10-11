import CountriesDomain
import SwiftUI

public extension EnvironmentValues {
    /// The data source screens build their view models with. The app injects the real one;
    /// the default throws, so previews and tests never touch the network by accident.
    @Entry var countriesRepository: any CountriesRepository = UnimplementedCountriesRepository()
}

/// Fails every call, making a missing `.environment(\.countriesRepository, …)` obvious.
struct UnimplementedCountriesRepository: CountriesRepository {
    func countries(matching _: String?) async throws(CountriesError) -> [CountrySummary] {
        throw .unknown
    }

    func country(code _: String) async throws(CountriesError) -> CountryDetail {
        throw .unknown
    }
}
