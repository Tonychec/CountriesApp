import CountriesAPI
import CountriesDomain
import Foundation

extension CountryDetailQuery.Data.Country {
    var domainModel: CountryDetail {
        CountryDetail(
            summary: fragments.countryBasics.domainModel,
            capital: capital,
            currencies: currencyCodes,
            languages: languages.map { CountriesDomain.Language(code: $0.code, name: $0.name) }
        )
    }

    /// The API sends currencies as one comma-separated string, e.g. `"USD,USN,USS"`, or `nil`.
    private var currencyCodes: [String] {
        (currency ?? "")
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
