public enum CountriesError: Error, Equatable, Sendable {
    /// Transport failure, offline or timeout.
    case network
    /// GraphQL `errors[]` in the response.
    case server(String)
    /// `country(code:)` returned `null`.
    case notFound
    case unknown
}
