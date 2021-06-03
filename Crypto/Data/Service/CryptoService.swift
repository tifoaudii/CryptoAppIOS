//
//  CryptoService.swift
//  Crypto
//
//  Created by ruangguru on 01/06/21.
//

import Foundation

class CryptoService {
    
    private let dataStore: NetworkDataStore
    
    init(dataStore: NetworkDataStore) {
        self.dataStore = dataStore
    }
    
    func fetchTopList(success: @escaping ([CoinData]) -> Void, failure: @escaping (ErrorResponse) -> Void) {
        dataStore.fetchTopList { (response: CoinResponse) in
            DispatchQueue.main.async {
                success(response.data)
            }
        } failure: { (error: ErrorResponse) in
            DispatchQueue.main.async {
                failure(error)
            }
        }
    }
    
    func fetchNews(success: @escaping ([NewsData]) -> Void, failure: @escaping (ErrorResponse) -> Void) {
        dataStore.fetchNews { (response: NewsResponse) in
            success(response.data)
        } failure: { (error: ErrorResponse) in
            failure(error)
        }
    }
}

public enum ErrorResponse: String {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    public var description: String {
        switch self {
        case .apiError: return "Ooops, there is something problem with the api"
        case .invalidEndpoint: return "Ooops, there is something problem with the endpoint"
        case .invalidResponse: return "Ooops, there is something problem with the response"
        case .noData: return "Ooops, there is something problem with the data"
        case .serializationError: return "Ooops, there is something problem with the serialization process"
        }
    }
}
