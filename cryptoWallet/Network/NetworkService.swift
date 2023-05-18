//
//  NetworkService.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 26.04.2023.
//

import UIKit

protocol NetworkServiceProtocol {
        
    func getCoinData(urlString: String, completion: @escaping (Result<Response?, Error>) -> Void)

}

class NetworkService: NetworkServiceProtocol {
    
    func getCoinData(urlString: String, completion: @escaping (Result<Response?, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let coinData = try JSONDecoder().decode(Response.self, from: data!)
                completion(.success(coinData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
