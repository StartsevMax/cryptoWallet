//
//  NetworkService.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 26.04.2023.
//

import UIKit

protocol NetworkServiceProtocol {
    
    func getCoins(completion: @escaping (Result<ResponseData?, Error>) -> Void)

}

class NetworkService: NetworkServiceProtocol {
    func getCoins(completion: @escaping (Result<ResponseData?, Error>) -> Void) {
        let urlString = "https://data.messari.io/api/v1/assets?fields=id,slug,symbol,metrics/market_data/price_usd"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(ResponseData.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

