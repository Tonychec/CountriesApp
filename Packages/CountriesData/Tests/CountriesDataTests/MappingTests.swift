import Apollo
import CountriesAPI
@testable import CountriesData
import CountriesDomain
import Foundation
import Testing

struct MappingTests {
    @Test func countriesMapToSummaries() async throws {
        let data: CountriesQuery.Data = try await fixture("countries")

        let summaries = data.countries.map(\.fragments.countryBasics.domainModel)

        #expect(summaries.map(\.code) == ["DE", "DZ", "NE", "NG"])
        #expect(summaries.first == CountrySummary(
            code: "DE",
            name: "Germany",
            emoji: "🇩🇪",
            continent: Continent(code: "EU", name: "Europe")
        ))
    }

    @Test func detailEmbedsSummaryAndSplitsCurrencies() async throws {
        let detail = try await countryDetail("country_us")

        #expect(detail.summary == CountrySummary(
            code: "US",
            name: "United States",
            emoji: "🇺🇸",
            continent: Continent(code: "NA", name: "North America")
        ))
        #expect(detail.capital == "Washington D.C.")
        #expect(detail.currencies == ["USD", "USN", "USS"])
    }

    @Test func detailKeepsLanguageOrder() async throws {
        let detail = try await countryDetail("country_ch")

        #expect(detail.languages == [
            Language(code: "de", name: "German"),
            Language(code: "fr", name: "French"),
            Language(code: "it", name: "Italian"),
        ])
    }

    @Test func nullFieldsMapToNilAndEmpty() async throws {
        let detail = try await countryDetail("country_null_fields")

        #expect(detail.capital == nil)
        #expect(detail.currencies.isEmpty)
        #expect(detail.languages.isEmpty)
    }

    // MARK: - Helpers

    private func countryDetail(_ name: String) async throws -> CountryDetail {
        let data: CountryDetailQuery.Data = try await fixture(name)
        return try #require(data.country).domainModel
    }

    /// Decodes `Fixtures/<name>.json`, a real API response, the same way Apollo parses network data.
    private func fixture<Data: RootSelectionSet>(_ name: String) async throws -> Data {
        let url = try #require(Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures"))
        let response = try JSONSerialization.jsonObject(with: Foundation.Data(contentsOf: url)) as? [String: Any]
        let data = try #require(response?["data"] as? [String: Any])
        return try await Data(data: data)
    }
}
