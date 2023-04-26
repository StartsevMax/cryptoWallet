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
                    self.model.coinList = responseData?.coins ?? []
                    self.view?.success()
                case .failure(let error):
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
        return model.coinList?[indexPath.row].metrics.price_usd ?? ""

    }
    
    func coinPricePercentChangeUsdLast24HoursForRow(at indexPath: IndexPath) -> String {
        return model.coinList?[indexPath.row].metrics.percent_change_usd_last_24_hours ?? ""

    }
    
    func sort(condition: ((CoinInfo, CoinInfo) -> Bool)) {
        model.sort(condition: condition)
    }
}



