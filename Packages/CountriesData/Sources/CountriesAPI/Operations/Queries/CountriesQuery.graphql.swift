// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CountriesQuery: GraphQLQuery {
  public static let operationName: String = "Countries"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Countries($filter: CountryFilterInput) { countries(filter: $filter) { __typename ...CountryBasics } }"#,
      fragments: [CountryBasics.self]
    ))

  public var filter: GraphQLNullable<CountryFilterInput>

  public init(filter: GraphQLNullable<CountryFilterInput>) {
    self.filter = filter
  }

  @_spi(Unsafe) public var __variables: Variables? { ["filter": filter] }

  nonisolated public struct Data: CountriesAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("countries", [Country].self, arguments: ["filter": .variable("filter")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CountriesQuery.Data.self
    ] }

    public var countries: [Country] { __data["countries"] }

    public init(
      countries: [Country]
    ) {
      self.init(unsafelyWithData: [
        "__typename": CountriesAPI.Objects.Query.typename,
        "countries": countries._fieldData,
      ])
    }

    /// Country
    ///
    /// Parent Type: `Country`
    nonisolated public struct Country: CountriesAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Country }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(CountryBasics.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CountriesQuery.Data.Country.self,
        CountryBasics.self
      ] }

      public var code: CountriesAPI.ID { __data["code"] }
      public var name: String { __data["name"] }
      public var emoji: String { __data["emoji"] }
      public var continent: Continent { __data["continent"] }

      public struct Fragments: FragmentContainer {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        public var countryBasics: CountryBasics { _toFragment() }
      }

      public init(
        code: CountriesAPI.ID,
        name: String,
        emoji: String,
        continent: Continent
      ) {
        self.init(unsafelyWithData: [
          "__typename": CountriesAPI.Objects.Country.typename,
          "code": code,
          "name": name,
          "emoji": emoji,
          "continent": continent._fieldData,
        ])
      }

      public typealias Continent = CountryBasics.Continent
    }
  }
}
