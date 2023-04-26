//
//  NetworkService.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 26.04.2023.
//

import UIKit

class NetworkService {
    
    var tableViewDelegate: TableViewProtocol?
    
    func getResponseData() {
        let fullUrl = URL(string: "https://data.messari.io/api/v1/assets?fields=id,slug,symbol,metrics")!
        
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept": "application/json"]
        request.httpBody = nil
        var responseData: ResponseData?
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                } else {
                    if let data = data {
                        responseData = try! JSONDecoder().decode(ResponseData.self, from: data)
                        self.tableViewDelegate?.didReceiveTableData(result: responseData)
                    }
                }
            }
            task.resume()
        }
    }
}

