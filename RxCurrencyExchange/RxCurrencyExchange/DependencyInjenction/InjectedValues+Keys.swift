//
//  InjectedValues+Extensions.swift
//  RxCurrencyExchange
//
//  Created by Pedro Ésli Vieira do Nascimento on 02/10/23.
//

import Foundation

private struct CurrencyProviderKey: InjectionKey {
    static var currentValue: CurrencyProviding = FreeCurrencyProvider()
}

extension InjectedValues {
    var currenyProvider: CurrencyProviding {
        get { Self[CurrencyProviderKey.self] }
        set { Self[CurrencyProviderKey.self] = newValue }
    }
}
