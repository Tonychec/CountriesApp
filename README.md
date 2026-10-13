# Countries

[![CI](https://github.com/Tonychec/CountriesApp/actions/workflows/ci.yml/badge.svg)](https://github.com/Tonychec/CountriesApp/actions/workflows/ci.yml)

An iOS app for browsing countries from the public [Countries GraphQL API](https://countries.trevorblades.com),
built with SwiftUI, Apollo iOS and local Swift packages.

- **List:** flag, name and continent for every country, with a debounced search by name and separate
  loading, no-results and error (with Retry) states.
- **Detail:** name, flag, capital, currencies, languages and continent, with loading and error states.
- Supports light and dark mode (semantic colours only) and Dynamic Type up to accessibility sizes.

## Requirements

| | |
|---|---|
| Xcode | 27.0 (27A266a) |
| Swift | 6, language mode with complete strict concurrency |
| iOS deployment target | 17.0 |
| Developed against | iPhone 18 Pro simulator, iOS 27.0 |
| Dependencies | [Apollo iOS](https://github.com/apollographql/apollo-ios) 2.x, resolved by Swift Package Manager |

## Build and run

1. Clone the repository.
2. Open `CountriesTestApp/CountriesTestApp.xcodeproj`. It references the three local packages in `Packages/`.
3. Select the `CountriesTestApp` scheme and an iOS simulator, then Run (⌘R).

Xcode resolves the Apollo package on first open. No API key or configuration is needed.

### Tests

The tests live in the packages (`CountriesDataTests`, `CountriesUITests`) and never touch the network.
Run `make test` to run both packages' tests.

To run them in Xcode, open the package itself (File › Open… › `Packages/CountriesData` or `Packages/CountriesUI`)
and press ⌘U. The app project only builds the packages as dependencies, so ⌘U there finds no tests.

### Tooling

| Command | What it does |
|---|---|
| `make bootstrap` | Installs SwiftFormat and SwiftLint with Homebrew |
| `make format` | Formats the code and applies SwiftLint autocorrections |
| `make lint` | SwiftLint (strict) and SwiftFormat in lint mode |
| `make guards` | Greps that enforce the architecture rules below |
| `make test` | Runs every test on the iPhone 18 Pro simulator |
| `make verify` | Build, lint, guards and tests in one go |
| `make codegen` | Downloads the schema and regenerates the Apollo code. Only needed when the operations in `Packages/CountriesData/graphql/` change |

GitHub Actions (`.github/workflows/ci.yml`) runs lint, guards, build and tests on every push to `main`
and on pull requests, using the `xcode-27` runner (Xcode 27.0, iPhone 18 Pro simulator).

## Architecture

```
┌───────────────────────── App target (CountriesTestApp) ─────────────────────────┐
│  MyApp.swift: @main, builds ApolloCountriesRepository, injects it via            │
│  .environment(\.countriesRepository, …), shows CountryListScreen                │
└───────────────┬───────────────────────────────────────────┬────────────────────┘
                │                                           │
        ┌───────▼────────┐                         ┌────────▼────────┐
        │ CountriesUI    │                         │ CountriesData   │
        │ (SwiftUI, VMs, │                         │  ├ CountriesData│ ← product
        │  Combine)      │                         │  │  (repository,│
        └───────┬────────┘                         │  │   mapping)   │
                │                                  │  └ CountriesAPI │ ← internal target,
                │                                  │     (generated) │   Apollo codegen
                │                                  └────────┬────────┘
                │          ┌─────────────────┐              │
                └─────────►│ CountriesDomain │◄─────────────┘
                           │ models, protocol│
                           │ errors (no deps)│
                           └─────────────────┘
```

- **CountriesDomain** has no dependencies. It holds the models (`CountrySummary`, `CountryDetail`, …),
  the `CountriesRepository` protocol and `CountriesError`.
- **CountriesData** is the only package that knows about Apollo. `ApolloCountriesRepository` runs the
  queries and maps the generated types to domain models at the boundary.
- **CountriesUI** depends only on CountriesDomain, so it can't import Apollo or generated types.
- **The app target** contains only `@main` and the composition code.

`make guards` checks these rules, plus no hardcoded colours, no completion handlers and no
`@unchecked Sendable` or `nonisolated(unsafe)`.

## Key decisions

- **Three packages, not two.** Putting the models and the repository protocol in their own package
  keeps the UI package free of Apollo, so the boundary is enforced by the compiler, not by convention.
- **Generated code is an internal target.** `CountriesAPI` lives inside the CountriesData package but
  is not a product, so no other package can import it. The generated code is committed, so the
  project builds straight after cloning without running codegen.
- **Server-side search.** The query sends a `regex` name filter. The API matches case-sensitively and
  rejects the `(?i)` flag, so `NameRegex` builds a case-insensitive pattern itself (`ger` →
  `[gG][eE][rR]`) after escaping regex metacharacters. A blank search sends no filter and returns
  every country.
- **Two seams for tests.** The UI depends on the `CountriesRepository` protocol, and the repository
  depends on `GraphQLFetching`, a one-method wrapper around `ApolloClient`. View model tests stub the
  repository; repository and mapping tests feed JSON fixtures through a stub fetcher.
- **Typed errors.** The repository only throws `CountriesError` (`throws(CountriesError)`).
  `ErrorMapping` turns Apollo and URL errors into it, and `CountriesError+Message` is the single place
  that writes user-facing text. A failure always shows an error state with Retry, never an empty list.
- **One state enum per screen.** `ListState` and `DetailState` are the single source of truth for what
  each screen shows, so the screen can't be loading and failed at the same time.
- **Stale results are dropped.** Each search cancels the previous request's `Task`, and cancelled
  results are ignored, so a slow older response can't overwrite a newer one.
- **Concurrency.** Swift 6 language mode everywhere. The app target's default actor isolation is
  `nonisolated`, so `@MainActor` is applied deliberately: on the view models, not across the board.
- **Combine debounce, 300 ms.** The search text goes through a `PassthroughSubject` with trimming,
  `removeDuplicates` and `debounce`. The interval is injectable so tests stay fast.
- **Network-only fetches.** Apollo's cache is bypassed, so there's no cache behaviour to reason about
  for data this small.
- **Repository via the environment.** `\.countriesRepository` lets both screens build their own view
  models, and its default throws, so a preview or test that forgets to inject one fails loudly
  instead of hitting the network. `LoadStateOverlay` is the shared loading and error UI for both screens.
- **Kept simple on purpose.** Two short, explicit view models rather than a generic
  `LoadableViewModel<T>`, and no third-party dependencies besides Apollo.
- **swift-testing** for all tests.

## Deliberately left out

- Offline caching and persistence.
- Pagination: the API returns all 250 countries at once.
- UI and snapshot tests.
- Localisation beyond English.

## With more time

- UI tests for navigation and the main states.
- Show the summary's flag and continent on the detail screen while the rest loads (today only the
  title does).
- Apollo's normalised cache, for offline support and instant repeat visits.
- Localisation.
- A dependency container if the app grows beyond one repository.
