import Combine
import CountriesDomain
import Foundation
import Observation

@MainActor
@Observable
final class CountryListViewModel {
    private(set) var state: ListState = .loading

    var searchText = "" {
        didSet { searchTextSubject.send(searchText) }
    }

    /// The in-flight load. Each new search cancels it, so a slow, older response can't overwrite a newer one.
    @ObservationIgnored private(set) var searchTask: Task<Void, Never>?
    @ObservationIgnored private let repository: any CountriesRepository
    @ObservationIgnored private let searchTextSubject = PassthroughSubject<String, Never>()
    @ObservationIgnored private var searchCancellable: AnyCancellable?

    init(
        repository: any CountriesRepository,
        debounceInterval: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(300)
    ) {
        self.repository = repository
        searchCancellable = searchTextSubject
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: debounceInterval, scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                // The main-queue scheduler delivers on the main actor; this checks it at runtime.
                MainActor.assumeIsolated {
                    self?.search(query)
                }
            }
    }

    /// First load when the screen appears. Does nothing on later appearances, e.g. returning from a detail.
    func loadInitial() async {
        guard searchTask == nil else { return }
        search(currentQuery)
        await searchTask?.value
    }

    func retry() {
        search(currentQuery)
    }

    func search(_ query: String) {
        searchTask?.cancel()
        searchTask = Task { await load(query) }
    }

    func load(_ query: String) async {
        state = .loading
        do throws(CountriesError) {
            let countries = try await repository.countries(matching: query.isEmpty ? nil : query)
            guard !Task.isCancelled else { return }
            state = countries.isEmpty ? .empty(query: query) : .loaded(countries)
        } catch {
            guard !Task.isCancelled else { return }
            state = .failed(error)
        }
    }

    private var currentQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
