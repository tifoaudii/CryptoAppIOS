//
//  NetworkDataStore.swift
//  Crypto
//
//  Created by ruangguru on 01/06/21.
//

import Foundation

protocol NetworkDataStore {
    func fetchTopList(success: @escaping (CoinResponse) -> Void, failure: @escaping (ErrorResponse) -> Void)
}

final class DefautNetworkDataStore: NetworkDataStore {
    
    private var baseURL: String = "https://min-api.cryptocompare.com/data"
    private let urlSession = URLSession.shared
    
    private enum Endpoint {
        case topList
        case news
        
        var URL: String {
            switch self {
            case .news:
                return "v2/news"
            default:
                return "top/totaltoptiervolfull"
            }
        }
    }
    
    func fetchTopList(success: @escaping (CoinResponse) -> Void, failure: @escaping (ErrorResponse) -> Void) {
        guard var urlComponent: URLComponents = URLComponents(string: "\(baseURL)/\(Endpoint.topList.URL)") else {
            return failure(.invalidEndpoint)
        }
        
        urlComponent.queryItems = [
            URLQueryItem(name: "limit", value: "50"),
            URLQueryItem(name: "tsym", value: "USD")
        ]
        
        let urlRequest: URLRequest = URLRequest(url: urlComponent.url!)
        
        urlSession.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                failure(.apiError)
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return failure(.invalidResponse)
            }
            
            guard let data = data else {
                return failure(.noData)
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let coinResponse = try jsonDecoder.decode(CoinResponse.self, from: data)
                DispatchQueue.main.async {
                    success(coinResponse)
                }
                
            } catch {
                DispatchQueue.main.async {
                    failure(.serializationError)
                }
            }
        }.resume()
    }
}