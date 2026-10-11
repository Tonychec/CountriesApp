import CountriesDomain
import SwiftUI

/// Full details for one country. Reads its data source from `\.countriesRepository`.
struct CountryDetailScreen: View {
    let country: CountrySummary

    @Environment(\.countriesRepository) private var repository

    var body: some View {
        CountryDetailContent(viewModel: CountryDetailViewModel(code: country.code, repository: repository))
            // Known from the list, so the title shows straight away while details load.
            .navigationTitle(country.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

/// Owns the view model; a separate view because the environment isn't readable in `CountryDetailScreen.init`.
private struct CountryDetailContent: View {
    /// `@State` keeps the first view model; later ones built by the parent's body are discarded.
    @State var viewModel: CountryDetailViewModel

    @ScaledMetric(relativeTo: .largeTitle) private var flagSize = 80

    var body: some View {
        List {
            if case let .loaded(detail) = viewModel.state {
                Section {
                    VStack {
                        Text(detail.summary.emoji)
                            .font(.system(size: flagSize))
                        Text(detail.summary.name)
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                Section {
                    LabeledContent("Capital", value: detail.capital ?? "—")
                    LabeledContent("Currencies", value: listed(detail.currencies))
                    LabeledContent("Languages", value: listed(detail.languages.map(\.name)))
                    LabeledContent("Continent", value: detail.summary.continent.name)
                }
            }
        }
        .loadStateOverlay(
            isLoading: viewModel.state == .loading,
            error: viewModel.state.error,
            retry: viewModel.retry
        )
        .task {
            await viewModel.load()
        }
    }

    private func listed(_ values: [String]) -> String {
        values.isEmpty ? "—" : values.formatted(.list(type: .and, width: .narrow))
    }
}

private extension DetailState {
    var error: CountriesError? {
        if case let .failed(error) = self {
            error
        } else {
            nil
        }
    }
}

// MARK: - Previews

#Preview("Loaded") {
    NavigationStack {
        CountryDetailScreen(country: CountryDetail.previewSample.summary)
    }
    .environment(\.countriesRepository, PreviewCountriesRepository(behavior: .detail(.previewSample)))
}

#Preview("Error") {
    NavigationStack {
        CountryDetailScreen(country: CountryDetail.previewSample.summary)
    }
    .environment(\.countriesRepository, PreviewCountriesRepository(behavior: .failure(.network)))
}

#Preview("Accessibility size") {
    NavigationStack {
        CountryDetailScreen(country: CountryDetail.previewSample.summary)
    }
    .environment(\.countriesRepository, PreviewCountriesRepository(behavior: .detail(.previewSample)))
    .environment(\.dynamicTypeSize, .accessibility5)
}
