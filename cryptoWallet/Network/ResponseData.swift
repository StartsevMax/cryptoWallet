//
//  ResponseData.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 26.04.2023.
//

import UIKit

// MARK: - Response

struct Response: Decodable {
    let status: Status
    let data: CoinData
}

// MARK: - Status

struct Status: Decodable {
    let elapsed: Int
    let timestamp: String
}

// MARK: - CoinData

struct CoinData: Decodable {
    let symbol: String
    let name: String
    let marketData: MarketData
    
    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case name = "name"
        case marketData = "market_data"
    }
}

// MARK: - MarketData

struct MarketData: Decodable {
    let priceUsd: Double
    let priceBtc: Double
    let priceEth: Double
    let volumeLast24Hours: Double
    let realVolumeLast24Hours: Double
    let volumeLast24HoursOverstatementMultiple: Double
    let percentChangeUsdLast1Hour: Double
    let percentChangeBtcLast1Hour: Double
    let percentChangeEthLast1Hour: Double
    let percentChangeUsdLast24Hours: Double
    let percentChangeBtcLast24Hours: Double
    let percentChangeEthLast24Hours: Double
    
    enum CodingKeys: String, CodingKey {
        case priceUsd = "price_usd"
        case priceBtc = "price_btc"
        case priceEth = "price_eth"
        case volumeLast24Hours = "volume_last_24_hours"
        case realVolumeLast24Hours = "real_volume_last_24_hours"
        case volumeLast24HoursOverstatementMultiple = "volume_last_24_hours_overstatement_multiple"
        case percentChangeUsdLast1Hour = "percent_change_usd_last_1_hour"
        case percentChangeBtcLast1Hour = "percent_change_btc_last_1_hour"
        case percentChangeEthLast1Hour = "percent_change_eth_last_1_hour"
        case percentChangeUsdLast24Hours = "percent_change_usd_last_24_hours"
        case percentChangeBtcLast24Hours = "percent_change_btc_last_24_hours"
        case percentChangeEthLast24Hours = "percent_change_eth_last_24_hours"
    }
}
