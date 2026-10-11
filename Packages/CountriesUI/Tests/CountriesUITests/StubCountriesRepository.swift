import CountriesDomain

/// A repository whose answers each test supplies as closures.
struct StubCountriesRepository: CountriesRepository {
    var fetchCountries: @Sendable (String?) async throws(CountriesError) -> [CountrySummary] = { _ in [] }
    var fetchCountry: @Sendable (String) async throws(CountriesError) -> CountryDetail = { _ throws(CountriesError) in
        throw .unknown
    }

    func countries(matching name: String?) async throws(CountriesError) -> [CountrySummary] {
        try await fetchCountries(name)
    }

    func country(code: String) async throws(CountriesError) -> CountryDetail {
        try await fetchCountry(code)
    }
}

/// Records the names a stub was asked for, safely across tasks.
actor QueryRecorder {
    private(set) var queries: [String?] = []

    func record(_ query: String?) {
        queries.append(query)
    }
}

/// Holds a stubbed response back until the test opens it, ignoring cancellation like a slow network.
actor Gate {
    private var isOpen = false
    private var waiters: [CheckedContinuation<Void, Never>] = []

    func wait() async {
        guard !isOpen else { return }
        await withCheckedContinuation { waiters.append($0) }
    }

    func open() {
        isOpen = true
        waiters.forEach { $0.resume() }
        waiters = []
    }
}

extension CountrySummary {
    static func stub(_ code: String) -> CountrySummary {
        CountrySummary(code: code, name: code, emoji: "🏳️", continent: Continent(code: "EU", name: "Europe"))
    }
}
