import CountriesDomain

/// Canned data for `#Preview`s, so previews work offline and can show every screen state.
struct PreviewCountriesRepository: CountriesRepository {
    enum Behavior {
        case countries([CountrySummary])
        case failure(CountriesError)
        /// Never answers, keeping the screen in its loading state.
        case loading
    }

    let behavior: Behavior

    func countries(matching _: String?) async throws(CountriesError) -> [CountrySummary] {
        switch behavior {
        case let .countries(countries):
            return countries
        case let .failure(error):
            throw error
        case .loading:
            try? await Task.sleep(for: .seconds(3600))
            throw .unknown
        }
    }

    func country(code _: String) async throws(CountriesError) -> CountryDetail {
        throw .unknown
    }
}

extension [CountrySummary] {
    static let previewSamples: [CountrySummary] = [
        CountrySummary(code: "DE", name: "Germany", emoji: "🇩🇪", continent: Continent(code: "EU", name: "Europe")),
        CountrySummary(code: "DZ", name: "Algeria", emoji: "🇩🇿", continent: Continent(code: "AF", name: "Africa")),
        CountrySummary(code: "NG", name: "Nigeria", emoji: "🇳🇬", continent: Continent(code: "AF", name: "Africa")),
        CountrySummary(
            code: "GS",
            name: "South Georgia and the South Sandwich Islands",
            emoji: "🇬🇸",
            continent: Continent(code: "AN", name: "Antarctica")
        ),
    ]
}
