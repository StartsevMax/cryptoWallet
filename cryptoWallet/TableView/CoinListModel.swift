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
    let metrics: MarketData
}

struct MarketData: Decodable {
    let price_usd: String
    let price_btc: String
    let price_eth: String
    let volume_last_24_hours: String
    let real_volume_last_24_hours: String
    let volume_last_24_hours_overstatement_multiple: String
    let percent_change_usd_last_1_hour: String
    let percent_change_btc_last_1_hour: String
    let percent_change_eth_last_1_hour: String
    let percent_change_usd_last_24_hours: String
    let percent_change_btc_last_24_hours: String
    let percent_change_eth_last_24_hours: String
}
