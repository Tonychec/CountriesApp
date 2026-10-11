import CountriesDomain
import SwiftUI

/// Searchable list of countries. Reads its data source from `\.countriesRepository`.
public struct CountryListScreen: View {
    @Environment(\.countriesRepository) private var repository

    public init() {}

    public var body: some View {
        NavigationStack {
            CountryList(viewModel: CountryListViewModel(repository: repository))
        }
    }
}

/// Owns the view model; a separate view because the environment isn't readable in `CountryListScreen.init`.
private struct CountryList: View {
    /// `@State` keeps the first view model; later ones built by the parent's body are discarded.
    @State var viewModel: CountryListViewModel

    var body: some View {
        List {
            ForEach(viewModel.state.countries, id: \.code) { country in
                NavigationLink(value: country) {
                    CountryRow(country: country)
                }
            }
        }
        .navigationTitle("Countries")
        .searchable(text: $viewModel.searchText, prompt: "Search countries")
        .loadStateOverlay(
            isLoading: viewModel.state == .loading,
            error: viewModel.state.error,
            retry: viewModel.retry
        )
        .overlay {
            if case let .empty(query) = viewModel.state {
                ContentUnavailableView.search(text: query)
            }
        }
        .navigationDestination(for: CountrySummary.self) { country in
            CountryDetailScreen(country: country)
        }
        .task {
            await viewModel.loadInitial()
        }
    }
}

private extension ListState {
    var countries: [CountrySummary] {
        if case let .loaded(countries) = self {
            countries
        } else {
            []
        }
    }

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
    CountryListScreen()
        .environment(\.countriesRepository, PreviewCountriesRepository(behavior: .countries(.previewSamples)))
}

#Preview("Empty") {
    CountryListScreen()
        .environment(\.countriesRepository, PreviewCountriesRepository(behavior: .countries([])))
}

#Preview("Error") {
    CountryListScreen()
        .environment(\.countriesRepository, PreviewCountriesRepository(behavior: .failure(.network)))
}

#Preview("Loading") {
    CountryListScreen()
        .environment(\.countriesRepository, PreviewCountriesRepository(behavior: .loading))
}

#Preview("Accessibility size") {
    CountryListScreen()
        .environment(\.countriesRepository, PreviewCountriesRepository(behavior: .countries(.previewSamples)))
        .environment(\.dynamicTypeSize, .accessibility5)
}
