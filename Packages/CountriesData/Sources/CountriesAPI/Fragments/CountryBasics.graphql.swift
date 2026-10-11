// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CountryBasics: CountriesAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment CountryBasics on Country { __typename code name emoji continent { __typename code name } }"#
  }

  @_spi(Unsafe) public let __data: DataDict
  @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

  @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Country }
  @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("code", CountriesAPI.ID.self),
    .field("name", String.self),
    .field("emoji", String.self),
    .field("continent", Continent.self),
  ] }
  @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
    CountryBasics.self
  ] }

  public var code: CountriesAPI.ID { __data["code"] }
  public var name: String { __data["name"] }
  public var emoji: String { __data["emoji"] }
  public var continent: Continent { __data["continent"] }

  /// Continent
  ///
  /// Parent Type: `Continent`
  nonisolated public struct Continent: CountriesAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Continent }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("code", CountriesAPI.ID.self),
      .field("name", String.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CountryBasics.Continent.self
    ] }

    public var code: CountriesAPI.ID { __data["code"] }
    public var name: String { __data["name"] }
  }
}
