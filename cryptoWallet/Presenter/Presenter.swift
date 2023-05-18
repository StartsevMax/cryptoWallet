//
//  CoinListViewPresenter.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 18.04.2023.
//

import UIKit

protocol ViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol PresenterProtocol: AnyObject {
    
    func setView(_ view: ViewProtocol)
    func numberOfSections() -> Int
    func numbersOfRowInSection(_ section: Int) -> Int
    func coinNameForRow(at indexPath: IndexPath) -> String
    func coinSymbolForRow(at indexPath: IndexPath) -> String
    func coinPriceUsdForRow(at indexPath: IndexPath) -> String
    func coinPricePercentChangeUsdLast24HoursForRow(at indexPath: IndexPath) -> String
    func sort(sorting: Sorting)
    func loadCoins(coinNames: [String])
    func loadCoinData(coinName: String)
    func getCoinData() -> CoinData?
}

final class Presenter: PresenterProtocol {
    private weak var view: ViewProtocol?
    private var networkService: NetworkServiceProtocol?
    private var model: CoinListModelProtocol = CoinListModel()
    private var coinList: [CoinData] = []
    
    init() {
        networkService = NetworkService()
    }
    
    func setView(_ view: ViewProtocol) {
        self.view = view
    }
    
    func loadCoins(coinNames: [String]) {
        let dispatchGroup = DispatchGroup()
        for coinName in coinNames {
            dispatchGroup.enter()
            let urlString = "https://data.messari.io/api/v1/assets/\(coinName)/metrics"
            networkService?.getCoinData(urlString: urlString, completion: { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let responseData):
                        if let coinData = responseData?.data {
                            self.coinList.append(coinData)
                            dispatchGroup.leave()
                        }
                    case .failure(let error):
                        self.view?.failure(error: error)
                    }
                }
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.model.coinList = self.coinList
            self.view?.success()
        }
        
    }
    
    func loadCoinData(coinName: String) {
        let urlString = "https://data.messari.io/api/v1/assets/\(coinName)/metrics"
        networkService?.getCoinData(urlString: urlString, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let responseData):
                    self.model.coinData = responseData?.data ?? nil
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
    
    func coinNameForRow(at indexPath: IndexPath) -> String {
        return model.coinList?[indexPath.row].name ?? ""
    }
    
    func coinSymbolForRow(at indexPath: IndexPath) -> String {
        return model.coinList?[indexPath.row].symbol ?? ""

    }
    
    func coinPriceUsdForRow(at indexPath: IndexPath) -> String {
        guard let valueDouble = model.coinList?[indexPath.row].marketData.priceUsd else { return "" }
        let valueString = String(format: "%.5f$", valueDouble)
        return valueString

    }
    
    func coinPricePercentChangeUsdLast24HoursForRow(at indexPath: IndexPath) -> String {
        guard let valueDouble = model.coinList?[indexPath.row].marketData.percentChangeUsdLast24Hours else { return "" }
        var valueString = ""
        if valueDouble > 0 {
            valueString = String(format: "+%.5f%%", valueDouble)
        } else {
            valueString = String(format: "%.5f%%", valueDouble)
        }
        return valueString
    }
    
    func sort(sorting: Sorting) {
        if sorting == Sorting.asc {
            model.sort { $0.marketData.percentChangeUsdLast24Hours > $1.marketData.percentChangeUsdLast24Hours }
        } else {
            model.sort { $0.marketData.percentChangeUsdLast24Hours < $1.marketData.percentChangeUsdLast24Hours }
        }
    }
    
    func getCoinData() -> CoinData? {
        return model.coinData
    }
}



