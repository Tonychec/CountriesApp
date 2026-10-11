import CountriesAPI
import CountriesDomain

extension CountryBasics {
    var domainModel: CountrySummary {
        CountrySummary(
            code: code,
            name: name,
            emoji: emoji,
            continent: CountriesDomain.Continent(code: continent.code, name: continent.name)
        )
    }
}
