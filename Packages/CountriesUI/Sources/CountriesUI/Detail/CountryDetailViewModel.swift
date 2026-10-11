import CountriesDomain
import Observation

/// Everything the detail screen can show; the view model's single source of screen state.
enum DetailState: Equatable {
    case loading
    case loaded(CountryDetail)
    case failed(CountriesError)
}

@MainActor
@Observable
final class CountryDetailViewModel {
    private(set) var state: DetailState = .loading

    @ObservationIgnored private let code: String
    @ObservationIgnored private let repository: any CountriesRepository

    init(code: String, repository: any CountriesRepository) {
        self.code = code
        self.repository = repository
    }

    func load() async {
        state = .loading
        do throws(CountriesError) {
            state = try await .loaded(repository.country(code: code))
        } catch {
            state = .failed(error)
        }
    }

    func retry() {
        Task { await load() }
    }
}
