import CountriesDomain
@testable import CountriesUI
import Testing

@MainActor
struct CountryListViewModelTests {
    private let countries: [CountrySummary] = [.stub("DE"), .stub("DZ"), .stub("NE")]

    @Test func successfulLoadShowsCountriesInOrder() async {
        let countries = countries
        let viewModel = CountryListViewModel(repository: StubCountriesRepository { _ in countries })

        await viewModel.load("")

        #expect(viewModel.state == .loaded(countries))
    }

    @Test func noMatchesShowsEmptyWithQuery() async {
        let viewModel = CountryListViewModel(repository: StubCountriesRepository { _ in [] })

        await viewModel.load("zzz")

        #expect(viewModel.state == .empty(query: "zzz"))
    }

    @Test func networkFailureShowsErrorNotEmptyList() async {
        let viewModel = CountryListViewModel(repository: StubCountriesRepository { _ throws(CountriesError) in
            throw .network
        })

        await viewModel.load("")

        #expect(viewModel.state == .failed(.network))
    }

    @Test func retryAfterFailureLoads() async {
        let countries = countries
        let recorder = QueryRecorder()
        let viewModel = CountryListViewModel(repository: StubCountriesRepository { query throws(CountriesError) in
            await recorder.record(query)
            guard await recorder.queries.count > 1 else { throw .network }
            return countries
        })
        await viewModel.loadInitial()
        #expect(viewModel.state == .failed(.network))

        viewModel.retry()
        await viewModel.searchTask?.value

        #expect(viewModel.state == .loaded(countries))
    }

    @Test func fastTypingSendsOneSearchWithLastText() async throws {
        let recorder = QueryRecorder()
        let interval = 20
        let viewModel = CountryListViewModel(
            repository: StubCountriesRepository { query in
                await recorder.record(query)
                return []
            },
            debounceInterval: .milliseconds(interval)
        )

        viewModel.searchText = "g"
        viewModel.searchText = "ge"
        viewModel.searchText = " ger "

        // Debounce is time-based, so the test has to wait: first for the search to arrive,
        // then a few more intervals to prove no second search follows.
        try await waitUntil { await !recorder.queries.isEmpty }
        try await Task.sleep(for: .milliseconds(interval * 5))
        #expect(await recorder.queries == ["ger"])
    }

    @Test func staleResponseDoesNotOverwriteNewerOne() async {
        let gate = Gate()
        let viewModel = CountryListViewModel(repository: StubCountriesRepository { query in
            if query == "slow" {
                await gate.wait()
                return [.stub("OLD")]
            }
            return [.stub("NEW")]
        })

        viewModel.search("slow")
        let slowSearch = viewModel.searchTask
        viewModel.search("fast")
        await viewModel.searchTask?.value
        await gate.open()
        await slowSearch?.value

        #expect(viewModel.state == .loaded([.stub("NEW")]))
    }

    // MARK: - Helpers

    /// Polls `condition` every few milliseconds, failing the test after `timeout`.
    private func waitUntil(
        timeout: Duration = .seconds(2),
        _ condition: () async -> Bool
    ) async throws {
        let deadline = ContinuousClock.now + timeout
        while await !condition() {
            try #require(ContinuousClock.now < deadline, "Timed out waiting for condition")
            try await Task.sleep(for: .milliseconds(5))
        }
    }
}
