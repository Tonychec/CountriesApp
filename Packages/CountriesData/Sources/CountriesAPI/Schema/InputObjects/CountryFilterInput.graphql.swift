// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CountryFilterInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    code: GraphQLNullable<StringQueryOperatorInput> = nil,
    continent: GraphQLNullable<StringQueryOperatorInput> = nil,
    currency: GraphQLNullable<StringQueryOperatorInput> = nil,
    name: GraphQLNullable<StringQueryOperatorInput> = nil
  ) {
    __data = InputDict([
      "code": code,
      "continent": continent,
      "currency": currency,
      "name": name
    ])
  }

  public var code: GraphQLNullable<StringQueryOperatorInput> {
    get { __data["code"] }
    set { __data["code"] = newValue }
  }

  public var continent: GraphQLNullable<StringQueryOperatorInput> {
    get { __data["continent"] }
    set { __data["continent"] = newValue }
  }

  public var currency: GraphQLNullable<StringQueryOperatorInput> {
    get { __data["currency"] }
    set { __data["currency"] = newValue }
  }

  public var name: GraphQLNullable<StringQueryOperatorInput> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }
}
