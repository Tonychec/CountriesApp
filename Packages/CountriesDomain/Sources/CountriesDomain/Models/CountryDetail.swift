/// Full country details; embeds the list summary instead of repeating its fields.
public struct CountryDetail: Hashable, Sendable, Identifiable {
    public let summary: CountrySummary
    /// `nil` when the API has no capital (e.g. Antarctica).
    public let capital: String?
    /// Currency codes, split from the API's comma-separated string.
    public let currencies: [String]
    public let languages: [Language]

    public var id: String {
        summary.id
    }

    public init(summary: CountrySummary, capital: String?, currencies: [String], languages: [Language]) {
        self.summary = summary
        self.capital = capital
        self.currencies = currencies
        self.languages = languages
    }
}
