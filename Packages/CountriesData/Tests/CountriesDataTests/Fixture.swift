import Apollo
import ApolloAPI
import Foundation
import Testing

/// Loads `Fixtures/<name>.json`, real API responses captured with the generated queries.
enum Fixture {
    /// Decodes the response's `data` the same way Apollo parses network data.
    static func data<Data: RootSelectionSet>(_ name: String) async throws -> Data {
        let url = try #require(Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures"))
        let response = try JSONSerialization.jsonObject(with: Foundation.Data(contentsOf: url)) as? [String: Any]
        let data = try #require(response?["data"] as? [String: Any])
        return try await Data(data: data)
    }
}
