import CountriesDomain

/// Canned data for `#Preview`s, so previews work offline and can show every screen state.
struct PreviewCountriesRepository: CountriesRepository {
    enum Behavior {
        case countries([CountrySummary])
        case detail(CountryDetail)
        case failure(CountriesError)
        /// Never answers, keeping the screen in its loading state.
        case loading
    }

    let behavior: Behavior

    func countries(matching _: String?) async throws(CountriesError) -> [CountrySummary] {
        switch behavior {
        case let .countries(countries):
            return countries
        case .detail:
            return []
        case let .failure(error):
            throw error
        case .loading:
            try await neverAnswer()
        }
    }

    func country(code _: String) async throws(CountriesError) -> CountryDetail {
        switch behavior {
        case let .detail(detail):
            return detail
        case .countries:
            throw .notFound
        case let .failure(error):
            throw error
        case .loading:
            try await neverAnswer()
        }
    }

    private func neverAnswer() async throws(CountriesError) -> Never {
        try? await Task.sleep(for: .seconds(3600))
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

extension CountryDetail {
    static let previewSample = CountryDetail(
        summary: CountrySummary(
            code: "CH",
            name: "Switzerland",
            emoji: "🇨🇭",
            continent: Continent(code: "EU", name: "Europe")
        ),
        capital: "Bern",
        currencies: ["CHE", "CHF", "CHW"],
        languages: [
            Language(code: "de", name: "German"),
            Language(code: "fr", name: "French"),
            Language(code: "it", name: "Italian"),
        ]
    )
}
