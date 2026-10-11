// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CountryDetailQuery: GraphQLQuery {
  public static let operationName: String = "CountryDetail"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CountryDetail($code: ID!) { country(code: $code) { __typename ...CountryBasics capital currency languages { __typename code name } } }"#,
      fragments: [CountryBasics.self]
    ))

  public var code: ID

  public init(code: ID) {
    self.code = code
  }

  @_spi(Unsafe) public var __variables: Variables? { ["code": code] }

  nonisolated public struct Data: CountriesAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("country", Country?.self, arguments: ["code": .variable("code")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CountryDetailQuery.Data.self
    ] }

    public var country: Country? { __data["country"] }

    public init(
      country: Country? = nil
    ) {
      self.init(unsafelyWithData: [
        "__typename": CountriesAPI.Objects.Query.typename,
        "country": country._fieldData,
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
        .field("capital", String?.self),
        .field("currency", String?.self),
        .field("languages", [Language].self),
        .fragment(CountryBasics.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CountryDetailQuery.Data.Country.self,
        CountryBasics.self
      ] }

      public var capital: String? { __data["capital"] }
      public var currency: String? { __data["currency"] }
      public var languages: [Language] { __data["languages"] }
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
        capital: String? = nil,
        currency: String? = nil,
        languages: [Language],
        code: CountriesAPI.ID,
        name: String,
        emoji: String,
        continent: Continent
      ) {
        self.init(unsafelyWithData: [
          "__typename": CountriesAPI.Objects.Country.typename,
          "capital": capital,
          "currency": currency,
          "languages": languages._fieldData,
          "code": code,
          "name": name,
          "emoji": emoji,
          "continent": continent._fieldData,
        ])
      }

      /// Country.Language
      ///
      /// Parent Type: `Language`
      nonisolated public struct Language: CountriesAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Language }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("code", CountriesAPI.ID.self),
          .field("name", String.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CountryDetailQuery.Data.Country.Language.self
        ] }

        public var code: CountriesAPI.ID { __data["code"] }
        public var name: String { __data["name"] }

        public init(
          code: CountriesAPI.ID,
          name: String
        ) {
          self.init(unsafelyWithData: [
            "__typename": CountriesAPI.Objects.Language.typename,
            "code": code,
            "name": name,
          ])
        }
      }

      public typealias Continent = CountryBasics.Continent
    }
  }
}
