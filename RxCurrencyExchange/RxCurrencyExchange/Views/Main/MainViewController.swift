//
//  MainViewController.swift
//  RxCurrencyExchange
//
//  Created by Pedro Ésli Vieira do Nascimento on 02/10/23.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var fromTextField: UITextField! {
        didSet {
            fromTextField.text = "1"
        }
    }
    @IBOutlet weak var toTextField: UITextField!
    @Injected(\.currenyProvider) var currenyProvider
    
    private var fromCurrency: CurrencySymbol = .usd
    private var toCurrency: CurrencySymbol = .brl
    private var exchangeRate: Double = 0
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        currenyProvider
            .fetchSupportedCurrencies()
            .subscribe { currencies in
                self.createFromButtonMenus(currencies: currencies)
                self.createToButtonMenus(currencies: currencies)
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
        currenyProvider
            .fetchCurrencyValue(from: fromCurrency, to: toCurrency)
            .subscribe { value in
                self.exchangeRate = value
                self.convertFromTo()
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
        fromTextField.rx.text
            .skip(1)
            .subscribe(onNext: { text in
                guard let text, !text.isEmpty else { return }
                self.fromTextFieldChange()
            })
            .disposed(by: disposeBag)
        toTextField.rx.text
            .skip(1)
            .subscribe(onNext: { text in
                guard let text, !text.isEmpty else { return }
                self.toTextFieldChange()
            })
            .disposed(by: disposeBag)
    }
    
    func createFromButtonMenus(currencies: [CurrencySymbol]) {
        var actions: [UIAction] = []
        currencies.forEach { currency in
            let action = UIAction(title: currency.name, subtitle: currency.code) { _ in
                self.fromPressedMenuOption(currency: currency)
            }
            if currency.code == fromCurrency.code {
                action.state = .on
            }
            actions.append(action)
        }
        fromButton.menu = UIMenu(children: actions)
        fromButton.showsMenuAsPrimaryAction = true
        fromButton.changesSelectionAsPrimaryAction = true
    }
    
    func createToButtonMenus(currencies: [CurrencySymbol]) {
        var actions: [UIAction] = []
        currencies.forEach { currency in
            let action = UIAction(title: currency.name, subtitle: currency.code) { _ in
                self.toPressedMenuOption(currency: currency)
            }
            if currency.code == toCurrency.code {
                action.state = .on
            }
            actions.append(action)
        }
        toButton.menu = UIMenu(children: actions)
        toButton.showsMenuAsPrimaryAction = true
        toButton.changesSelectionAsPrimaryAction = true
    }
    
    func fromPressedMenuOption(currency: CurrencySymbol) {
        fromCurrency = currency
        currenyProvider
            .fetchCurrencyValue(from: fromCurrency, to: toCurrency)
            .subscribe { value in
                self.exchangeRate = value
                self.convertFromTo()
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func toPressedMenuOption(currency: CurrencySymbol) {
        toCurrency = currency
        currenyProvider
            .fetchCurrencyValue(from: fromCurrency, to: toCurrency)
            .subscribe { value in
                self.exchangeRate = value
                self.convertToFrom()
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func fromTextFieldChange() {
        convertFromTo()
    }
    
    func toTextFieldChange() {
        convertToFrom()
    }
    
    func convertFromTo() {
        guard let fromValue = Double(fromTextField.text ?? "0") else { return }
        let result = fromValue * exchangeRate
        toTextField.text = String(format: "%.2f", result)
    }
    
    func convertToFrom() {
        guard let toValue = Double(toTextField.text ?? "0") else { return }
        let result = toValue / exchangeRate
        fromTextField.text = String(format: "%.2f", result)
    }
    
}
