/// A country as shown in the list; maps from the `CountryBasics` fragment.
public struct CountrySummary: Hashable, Sendable, Identifiable {
    /// ISO 3166-1 alpha-2 code, also the stable `id`.
    public let code: String
    public let name: String
    public let emoji: String
    public let continent: Continent

    public var id: String {
        code
    }

    public init(code: String, name: String, emoji: String, continent: Continent) {
        self.code = code
        self.name = name
        self.emoji = emoji
        self.continent = continent
    }
}
