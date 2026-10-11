import Apollo
import CountriesAPI
import CountriesDomain
import Foundation

/// `CountriesRepository` backed by the Countries GraphQL API.
public struct ApolloCountriesRepository: CountriesRepository {
    private let client: any GraphQLFetching

    init(client: any GraphQLFetching) {
        self.client = client
    }

    public static func live(url: URL) -> ApolloCountriesRepository {
        ApolloCountriesRepository(client: ApolloClient(url: url))
    }

    public func countries(matching name: String?) async throws(CountriesError) -> [CountrySummary] {
        let filter: GraphQLNullable<CountryFilterInput> =
            if let pattern = name.flatMap(NameRegex.caseInsensitivePattern(for:)) {
                .some(CountryFilterInput(name: .some(StringQueryOperatorInput(regex: .some(pattern)))))
            } else {
                .none
            }
        let data = try await data(for: CountriesQuery(filter: filter))
        return data.countries.map(\.fragments.countryBasics.domainModel)
    }

    public func country(code: String) async throws(CountriesError) -> CountryDetail {
        let data = try await data(for: CountryDetailQuery(code: code))
        guard let country = data.country else {
            throw .notFound
        }
        return country.domainModel
    }

    private func data<Query: GraphQLQuery>(for query: Query) async throws(CountriesError) -> Query.Data
        where Query.ResponseFormat == SingleResponseFormat
    {
        let response: GraphQLResponse<Query>
        do {
            response = try await client.fetch(query)
        } catch {
            throw ErrorMapping.countriesError(from: error)
        }
        guard let data = response.data else {
            throw ErrorMapping.countriesError(fromMissingDataWith: response.errors)
        }
        return data
    }
}
