import Apollo
import CountriesAPI
@testable import CountriesData
import CountriesDomain
import Foundation
import Testing

struct ApolloCountriesRepositoryTests {
    // MARK: - Filter

    @Test(arguments: [nil, "", "   "])
    func blankNameSendsNoFilter(name: String?) async throws {
        let fetcher = StubGraphQLFetcher(.fixture("countries"))

        _ = try await ApolloCountriesRepository(client: fetcher).countries(matching: name)

        #expect(try await sentCountriesQuery(fetcher) == CountriesQuery(filter: .none))
    }

    @Test func nameSendsCaseInsensitiveRegex() async throws {
        let fetcher = StubGraphQLFetcher(.fixture("countries"))

        let countries = try await ApolloCountriesRepository(client: fetcher).countries(matching: "ger")

        let expectedFilter = CountryFilterInput(name: .some(StringQueryOperatorInput(regex: .some("[gG][eE][rR]"))))
        #expect(try await sentCountriesQuery(fetcher) == CountriesQuery(filter: .some(expectedFilter)))
        #expect(countries.map(\.code) == ["DE", "DZ", "NE", "NG"])
    }

    // MARK: - Detail

    @Test func countryMapsDetail() async throws {
        let repository = ApolloCountriesRepository(client: StubGraphQLFetcher(.fixture("country_us")))

        let detail = try await repository.country(code: "US")

        #expect(detail.summary.code == "US")
        #expect(detail.currencies == ["USD", "USN", "USS"])
    }

    @Test func nullCountryThrowsNotFound() async {
        let repository = ApolloCountriesRepository(client: StubGraphQLFetcher(.fixture("country_not_found")))

        await #expect(throws: CountriesError.notFound) {
            try await repository.country(code: "XX")
        }
    }

    // MARK: - Error mapping

    @Test(arguments: [
        URLError(.notConnectedToInternet),
        URLError(.timedOut),
    ])
    func transportFailureThrowsNetwork(error: URLError) async {
        let repository = ApolloCountriesRepository(client: StubGraphQLFetcher(.failure(error)))

        await #expect(throws: CountriesError.network) {
            try await repository.countries(matching: nil)
        }
    }

    @Test func graphQLErrorsThrowServerWithMessage() async {
        let errors = [GraphQLError(["message": "Unexpected error."])]
        let repository = ApolloCountriesRepository(client: StubGraphQLFetcher(.errors(errors)))

        await #expect(throws: CountriesError.server("Unexpected error.")) {
            try await repository.countries(matching: "(")
        }
    }

    @Test func missingDataWithoutErrorsThrowsUnknown() async {
        let repository = ApolloCountriesRepository(client: StubGraphQLFetcher(.errors([])))

        await #expect(throws: CountriesError.unknown) {
            try await repository.country(code: "US")
        }
    }

    @Test func unexpectedErrorThrowsUnknown() async {
        let repository = ApolloCountriesRepository(client: StubGraphQLFetcher(.failure(CancellationError())))

        await #expect(throws: CountriesError.unknown) {
            try await repository.countries(matching: nil)
        }
    }

    // MARK: - Helpers

    private func sentCountriesQuery(_ fetcher: StubGraphQLFetcher) async throws -> CountriesQuery {
        let queries = await fetcher.fetchedQueries
        #expect(queries.count == 1)
        return try #require(queries.first as? CountriesQuery)
    }
}
