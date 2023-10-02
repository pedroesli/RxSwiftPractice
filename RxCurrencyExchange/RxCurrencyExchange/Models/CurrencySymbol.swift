//
//  CurrencySymbol.swift
//  RxCurrencyExchange
//
//  Created by Pedro Ésli Vieira do Nascimento on 02/10/23.
//

struct CurrencySymbol: Decodable {
    /// Three-letter currency code
    let code: String
    /// Name of the currency
    let name: String
}

extension CurrencySymbol {
    static let usd = CurrencySymbol(code: "usd", name: "US Dollar")
    static let brl = CurrencySymbol(code: "brl", name: "Brazilian Real")
}
