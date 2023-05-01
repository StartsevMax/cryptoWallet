//
//  CoinListModel.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 18.04.2023.
//

import UIKit

protocol CoinListModelProtocol {
    var coinList: [CoinInfo]? { get set }
    mutating func sort(condition: ((CoinInfo, CoinInfo) -> Bool))
}

struct CoinListModel: CoinListModelProtocol {
    
    var coinList: [CoinInfo]?
    
    mutating func sort(condition: ((CoinInfo, CoinInfo) -> Bool)) {
        coinList?.sort(by: condition)
    }
    
}

struct CoinInfo: Decodable {
    let slug: String
    let symbol: String
    let metrics: Metrics
}

struct Metrics: Decodable {
    let market_data: MarketData
}

struct MarketData: Decodable {
    let price_usd: Double
    let percent_change_usd_last_24_hours: Double
}
