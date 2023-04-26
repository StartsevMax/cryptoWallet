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
    
    func setView(_ view: CoinListViewProtocol)

    func numberOfSections() -> Int
    
    func numbersOfRowInSection(_ section: Int) -> Int
    
    func coinSlugForRow(at indexPath: IndexPath) -> String

    func coinSymbolForRow(at indexPath: IndexPath) -> String

    func coinPriceUsdForRow(at indexPath: IndexPath) -> String
    
    func coinPricePercentChangeUsdLast24HoursForRow(at indexPath: IndexPath) -> String
    
    func sort(condition: (CoinInfo, CoinInfo) -> Bool)
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
    
    func coinSlugForRow(at indexPath: IndexPath) -> String {
        return model.coinList[indexPath.row].slug
    }
    
    func coinSymbolForRow(at indexPath: IndexPath) -> String {
        return model.coinList[indexPath.row].symbol

    }
    
    func coinPriceUsdForRow(at indexPath: IndexPath) -> String {
        return model.coinList[indexPath.row].metrics.price_usd

    }
    
    func coinPricePercentChangeUsdLast24HoursForRow(at indexPath: IndexPath) -> String {
        return model.coinList[indexPath.row].metrics.percent_change_usd_last_24_hours

    }
    
    func sort(condition: ((CoinInfo, CoinInfo) -> Bool)) {
        model.sort(condition: condition)
    }
}



