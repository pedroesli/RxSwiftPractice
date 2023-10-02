//
//  CurrencyProviding.swift
//  RxCurrencyExchange
//
//  Created by Pedro Ésli Vieira do Nascimento on 02/10/23.
//

import RxSwift

enum CurrencyProvidingError: Error {
    case responseError(_ reason: String)
    case providerError(_ reason: String)
    case dataError(_ reason: String)
}

protocol CurrencyProviding {
    func fetchSupportedCurrencies() -> Single<[CurrencySymbol]>
}
