//
//  ResponseData.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 26.04.2023.
//

import UIKit

struct ResponseData: Decodable {
    let status: Status
    let data: [CoinInfo]
}

struct Status: Decodable {
    let elapsed: String
    let timestamp: String
}
