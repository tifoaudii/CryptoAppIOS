import Foundation

// MARK: - Coin
struct CoinResponse: Codable {
    let data: [CoinData]

    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

// MARK: - Datum
struct CoinData: Codable {
    let coinInfo: CoinInfo
    let raw: Raw?
    
    enum CodingKeys: String, CodingKey {
        case coinInfo = "CoinInfo"
        case raw = "RAW"
    }
    
    var symbol: String {
        "2~Binance~\(coinInfo.name)~USDT"
    }
}

// MARK: - CoinInfo
struct CoinInfo: Codable {
    let id, name, fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case fullName = "FullName"
    }
}

// MARK: - Raw
struct Raw: Codable {
    let usd: RawUsd

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// MARK: - RawUsd
struct RawUsd: Codable {
    let price, openday: Double

    enum CodingKeys: String, CodingKey {
        case price = "PRICE"
        case openday = "OPENDAY"
    }
}
