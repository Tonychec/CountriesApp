import CountriesDomain

extension CountriesError {
    /// The only place user-facing error text is written.
    var localizedMessage: String {
        switch self {
        case .network:
            "Check your internet connection and try again."
        case .server:
            // The server's own message is for debugging, not for people.
            "The server couldn't complete the request. Please try again later."
        case .notFound:
            "This country couldn't be found."
        case .unknown:
            "Something went wrong. Please try again."
        }
    }
}
