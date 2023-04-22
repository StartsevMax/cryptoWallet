//
//  CoinListViewPresenter.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 18.04.2023.
//

import UIKit

protocol CoinListViewProtocol: AnyObject {
    
    func reloadTable()
    
}

protocol CoinListPresenterProtocol: AnyObject {
    
    // Устанавливаем View для Presenter
    func setView(_ view: CoinListViewProtocol)

    func numberOfSections() -> Int
    
    func numbersOfRowInSection(_ section: Int) -> Int
    
    func coinNameForRow(at indexPath: IndexPath) -> String

    func coinSymbolForRow(at indexPath: IndexPath) -> String

    func coinPriceForRow(at indexPath: IndexPath) -> Float
    
    func sortAsc()
    
    func sortDesc()
    
}

final class CoinListPresenter: CoinListPresenterProtocol {

    private weak var view: CoinListViewProtocol?
    
    private var model: CoinListModel = CoinListModel()
    
    func setView(_ view: CoinListViewProtocol) {
        self.view = view
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numbersOfRowInSection(_ section: Int) -> Int {
        return model.coinList.count
    }
    
    func coinNameForRow(at indexPath: IndexPath) -> String {
        return model.coinList[indexPath.row].name
    }
    
    func coinSymbolForRow(at indexPath: IndexPath) -> String {
        return model.coinList[indexPath.row].symbol

    }
    
    func coinPriceForRow(at indexPath: IndexPath) -> Float {
        return model.coinList[indexPath.row].price

    }
    
    func sortAsc() {
        model.sortAsc()
    }
    
    func sortDesc() {
        model.sortDesc()
    }
    
}



