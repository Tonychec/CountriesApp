import CountriesDomain
@testable import CountriesUI
import Testing

@MainActor
struct CountryDetailViewModelTests {
    @Test func successfulLoadShowsDetailForRequestedCode() async {
        let recorder = QueryRecorder()
        let detail = CountryDetail(
            summary: .stub("CH"),
            capital: "Bern",
            currencies: ["CHF"],
            languages: [Language(code: "de", name: "German")]
        )
        let viewModel = CountryDetailViewModel(code: "CH", repository: StubCountriesRepository(fetchCountry: { code in
            await recorder.record(code)
            return detail
        }))

        await viewModel.load()

        #expect(viewModel.state == .loaded(detail))
        #expect(await recorder.queries == ["CH"])
    }

    @Test(arguments: [CountriesError.network, .notFound])
    func failureShowsError(error: CountriesError) async {
        let viewModel = CountryDetailViewModel(
            code: "XX",
            repository: StubCountriesRepository(fetchCountry: { _ throws(CountriesError) in
                throw error
            })
        )

        await viewModel.load()

        #expect(viewModel.state == .failed(error))
    }
}
