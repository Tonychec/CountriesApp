import CountriesDomain
import SwiftUI

/// Covers a screen's content with a spinner while loading, or an error with a Retry button.
struct LoadStateOverlay: ViewModifier {
    let isLoading: Bool
    let error: CountriesError?
    let retry: @MainActor () -> Void

    func body(content: Content) -> some View {
        content.overlay {
            if isLoading {
                ProgressView("Loading…")
            } else if let error {
                ContentUnavailableView {
                    Label("Unable to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.localizedMessage)
                } actions: {
                    Button("Retry", action: retry)
                        .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

extension View {
    func loadStateOverlay(
        isLoading: Bool,
        error: CountriesError?,
        retry: @escaping @MainActor () -> Void
    ) -> some View {
        modifier(LoadStateOverlay(isLoading: isLoading, error: error, retry: retry))
    }
}

#Preview("Loading") {
    List {}
        .loadStateOverlay(isLoading: true, error: nil) {}
}

#Preview("Error") {
    List {}
        .loadStateOverlay(isLoading: false, error: .network) {}
}
