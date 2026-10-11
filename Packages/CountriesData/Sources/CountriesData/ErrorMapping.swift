import Apollo
import CountriesDomain
import Foundation

/// Translates Apollo outcomes into `CountriesError`, the only error the repository throws (PLAN.md §1.9).
enum ErrorMapping {
    static func countriesError(from error: any Error) -> CountriesError {
        switch error {
        case is URLError,
             is ResponseCodeInterceptor.ResponseCodeError,
             is JSONResponseParsingError:
            .network
        default:
            .unknown
        }
    }

    /// A response without `data`: the server's GraphQL errors explain why, if it sent any.
    static func countriesError(fromMissingDataWith errors: [GraphQLError]?) -> CountriesError {
        guard let message = errors?.compactMap(\.message).first else {
            return .unknown
        }
        return .server(message)
    }
}
