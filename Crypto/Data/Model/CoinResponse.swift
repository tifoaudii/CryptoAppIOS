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
    
    static var streamURL: URL {
        .init(string: "wss://streamer.cryptocompare.com/v2?api_key=4c6ec4fa84b66963743a2a2ea291ec5e6216fe1c5453046f3b16c186878743b5")!
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
