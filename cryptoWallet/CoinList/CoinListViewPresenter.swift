//
//  CoinListViewPresenter.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 18.04.2023.
//

import UIKit

protocol CoinListViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
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
    
    func getCoins()
}

final class CoinListPresenter: CoinListPresenterProtocol {
    
    private weak var view: CoinListViewProtocol?
    private var networkService: NetworkServiceProtocol?
    private var model: CoinListModelProtocol = CoinListModel()
    
    init() {
        networkService = NetworkService()
        getCoins()
    }
    
    func setView(_ view: CoinListViewProtocol) {
        self.view = view
    }
    
    func getCoins() {
        networkService?.getCoins(completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let responseData):
                    self.model.coinList = responseData?.data ?? []
                    self.view?.success()
                case .failure(let error):
                    print(error)
                    self.view?.failure(error: error)
                }
            }
        })
    }

    func numberOfSections() -> Int {
        1
    }
    
    func numbersOfRowInSection(_ section: Int) -> Int {
        return model.coinList?.count ?? 0
    }
    
    func coinSlugForRow(at indexPath: IndexPath) -> String {
        return model.coinList?[indexPath.row].slug ?? ""
    }
    
    func coinSymbolForRow(at indexPath: IndexPath) -> String {
        return model.coinList?[indexPath.row].symbol ?? ""

    }
    
    func coinPriceUsdForRow(at indexPath: IndexPath) -> String {
        let valueDouble = model.coinList?[indexPath.row].metrics.market_data.price_usd ?? 0.0
        let valueString = String(format: "%.5f$", valueDouble)
        return valueString

    }
    
    func coinPricePercentChangeUsdLast24HoursForRow(at indexPath: IndexPath) -> String {
        let valueDouble = model.coinList?[indexPath.row].metrics.market_data.percent_change_usd_last_24_hours ?? 0.0
        var valueString = ""
        if valueDouble > 0 {
            valueString = String(format: "+%.5f", valueDouble)
        } else if valueDouble < 0 {
            valueString = String(format: "%.5f", valueDouble)
        }
        return valueString + "%"
    }
    
    func sort(condition: ((CoinInfo, CoinInfo) -> Bool)) {
        model.sort(condition: condition)
    }
}



