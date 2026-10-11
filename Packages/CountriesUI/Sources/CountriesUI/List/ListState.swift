import CountriesDomain

/// Everything the list screen can show; the view model's single source of screen state.
enum ListState: Equatable {
    case loading
    case loaded([CountrySummary])
    /// The search succeeded but nothing matched `query`.
    case empty(query: String)
    case failed(CountriesError)
}
