//
//  FixerProvider.swift
//  RxCurrencyExchange
//
//  Created by Pedro Ésli Vieira do Nascimento on 01/10/23.
//
//  https://github.com/fawazahmed0/currency-api#readme

import RxSwift
import Alamofire
import SwiftyJSON
import Foundation

struct FreeCurrencyProvider: CurrencyProviding {
    
    let baseUrl = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1"
    
    func fetchSupportedCurrencies() -> Single<[CurrencySymbol]> {
        return Single.create { single in
            let url = baseUrl + "/latest/currencies.json"
            AF.request(url)
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let data):
                        guard let data else {
                            single(.failure(CurrencyProvidingError.dataError("Data is nil")))
                            return
                        }
                        guard let dictionary = try? JSON(data: data).dictionary else {
                            single(.failure(CurrencyProvidingError.dataError("Data could not be converted to Json")))
                            return
                        }
                        var symbols: [CurrencySymbol] = []
                        dictionary.forEach { element in
                            symbols.append(CurrencySymbol(code: element.key, name: element.value.stringValue))
                        }
                        symbols = symbols
                            .filter({ !$0.name.isEmpty })
                            .sorted(by: { $0.name < $1.name })
                        single(.success(symbols))
                    case .failure(let error):
                        let responseError = CurrencyProvidingError.responseError(error.errorDescription ?? "Request failed")
                        single(.failure(responseError))
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchCurrencyValue(from: CurrencySymbol, to: CurrencySymbol) -> Single<Double> {
        return Single.create { single in
            let url = baseUrl + "/latest/currencies/\(from.code)/\(to.code).json"
            AF.request(url)
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let data):
                        guard let data else {
                            single(.failure(CurrencyProvidingError.dataError("Data is nil")))
                            return
                        }
                        guard let json = try? JSON(data: data) else {
                            single(.failure(CurrencyProvidingError.dataError("Data could not be converted to Json")))
                            return
                        }
                        single(.success(json[to.code].doubleValue))
                    case .failure(let error):
                        let responseError = CurrencyProvidingError.responseError(error.errorDescription ?? "Request failed")
                        single(.failure(responseError))
                    }
                }
            return Disposables.create()
        }
    }
}
