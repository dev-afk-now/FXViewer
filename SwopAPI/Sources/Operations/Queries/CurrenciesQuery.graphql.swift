// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CurrenciesQuery: GraphQLQuery {
  public static let operationName: String = "Currencies"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Currencies { currencies { __typename code name numericCode decimalDigits active } }"#
    ))

  public init() {}

  public struct Data: SwopAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { SwopAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("currencies", [Currency].self),
    ] }

    public var currencies: [Currency] { __data["currencies"] }

    /// Currency
    ///
    /// Parent Type: `CurrencyType`
    public struct Currency: SwopAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { SwopAPI.Objects.CurrencyType }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("code", String.self),
        .field("name", String.self),
        .field("numericCode", String?.self),
        .field("decimalDigits", Int.self),
        .field("active", Bool.self),
      ] }

      public var code: String { __data["code"] }
      public var name: String { __data["name"] }
      public var numericCode: String? { __data["numericCode"] }
      public var decimalDigits: Int { __data["decimalDigits"] }
      public var active: Bool { __data["active"] }
    }
  }
}
