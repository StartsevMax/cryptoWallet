//
//  ResponseData.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 26.04.2023.
//

import UIKit

struct ResponseData: Decodable {
    let status: String
    let coins: [CoinInfo]
}

