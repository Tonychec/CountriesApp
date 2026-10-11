import Apollo
import ApolloAPI

/// The one Apollo call the repository needs; lets tests stub responses and errors without a network.
protocol GraphQLFetching: Sendable {
    func fetch<Query: GraphQLQuery>(_ query: Query) async throws -> GraphQLResponse<Query>
        where Query.ResponseFormat == SingleResponseFormat
}

extension ApolloClient: GraphQLFetching {
    /// Always asks the server, so results are fresh and there's no cache behaviour to reason about.
    func fetch<Query: GraphQLQuery>(_ query: Query) async throws -> GraphQLResponse<Query>
        where Query.ResponseFormat == SingleResponseFormat
    {
        try await fetch(query: query, cachePolicy: .networkOnly)
    }
}
