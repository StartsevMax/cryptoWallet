//
//  CoinListModel.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 18.04.2023.
//

import UIKit

struct CoinListModel {
    
    var coinList: [CoinInfo] {
        return privateCoinList
    }
    
    private var privateCoinList: [CoinInfo] = []
    
    init() {
        setupDefaultCoins()
    }
    
    private mutating func setupDefaultCoins() {
        let bitcoin = CoinInfo(name: "Bitcoin", symbol: "BTC", price: 29457.9346)
        let tether = CoinInfo(name: "Tether", symbol: "USDT", price: 1.0123)
        let dogecoin = CoinInfo(name: "Dogecoin", symbol: "Doge", price: 201.3412)

        privateCoinList = [bitcoin, tether, dogecoin]
    }
    
    mutating func sort(condition: ((CoinInfo, CoinInfo) -> Bool)) {
        privateCoinList.sort(by: condition)
    }

}

struct CoinInfo {
    
    let name: String
    
    let symbol: String
    
    let price: Float
    
}
