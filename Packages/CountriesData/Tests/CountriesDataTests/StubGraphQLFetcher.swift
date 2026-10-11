import Apollo
import ApolloAPI
@testable import CountriesData
import Foundation

/// Answers every fetch with one canned outcome and records the queries it was asked for.
actor StubGraphQLFetcher: GraphQLFetching {
    enum Outcome {
        /// A successful response whose `data` comes from `Fixtures/<name>.json`.
        case fixture(String)
        /// A response with GraphQL `errors` and no `data`.
        case errors([GraphQLError])
        /// The fetch throws, as Apollo does for transport failures.
        case failure(any Error)
    }

    private let outcome: Outcome
    private(set) var fetchedQueries: [any GraphQLQuery] = []

    init(_ outcome: Outcome) {
        self.outcome = outcome
    }

    func fetch<Query: GraphQLQuery>(_ query: Query) async throws -> GraphQLResponse<Query>
        where Query.ResponseFormat == SingleResponseFormat
    {
        fetchedQueries.append(query)
        switch outcome {
        case let .fixture(name):
            return try await response(data: Fixture.data(name), errors: nil)
        case let .errors(errors):
            return response(data: nil, errors: errors)
        case let .failure(error):
            throw error
        }
    }

    private func response<Query>(data: Query.Data?, errors: [GraphQLError]?) -> GraphQLResponse<Query> {
        GraphQLResponse(data: data, extensions: nil, errors: errors, source: .server, dependentKeys: nil)
    }
}
