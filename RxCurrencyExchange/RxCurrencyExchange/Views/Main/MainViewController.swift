//
//  MainViewController.swift
//  RxCurrencyExchange
//
//  Created by Pedro Ésli Vieira do Nascimento on 02/10/23.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    @Injected(\.currenyProvider) var currenyProvider
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        currenyProvider
            .fetchSupportedCurrencies()
            .subscribe { currencies in
                print("Currencies: \(currencies)")
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}
