//
//  CoinListModel.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 18.04.2023.
//

import UIKit

protocol CoinListModelProtocol {
    var coinList: [CoinData]? { get set }
    var coinData: CoinData? { get set }
    
    mutating func sort(condition: ((CoinData, CoinData) -> Bool))
}

struct CoinListModel: CoinListModelProtocol {
    var coinList: [CoinData]?
    var coinData: CoinData?
    
    mutating func sort(condition: ((CoinData, CoinData) -> Bool)) {
        coinList?.sort(by: condition)
    }
}


