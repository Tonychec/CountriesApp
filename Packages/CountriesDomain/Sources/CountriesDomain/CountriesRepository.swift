/// Source of country data. Conformances throw only `CountriesError`
/// and return `[]` (not an error) when nothing matches.
public protocol CountriesRepository: Sendable {
    /// Countries whose name matches `name`, or all countries when `name` is `nil`.
    func countries(matching name: String?) async throws(CountriesError) -> [CountrySummary]
    func country(code: String) async throws(CountriesError) -> CountryDetail
}
