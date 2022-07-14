//
//  MockNetworkDataStore.swift
//  CryptoTests
//
//  Created by Tifo Audi Alif Putra on 02/06/21.
//

@testable import Crypto
import Foundation

class MockNetworkDataStore: NetworkDataStore {
    
    private let testScenario: TestScenario
    
    init(testScenario: TestScenario) {
        self.testScenario = testScenario
    }
    
    let mockCoinResponse = [
        CoinData(
            coinInfo:
                CoinInfo(id: "", name: "", fullName: "", coinInfoInternal: "", imageURL: "", url: "", algorithm: "", proofType: "", rating: Rating(weiss: Weiss(rating: "", technologyAdoptionRating: "", marketPerformanceRating: "")), netHashesPerSecond: 0, blockNumber: 0, blockTime: 0, blockReward: 0, assetLaunchDate: "", maxSupply: 0, type: 0, documentType: .webpagecoinp),
            raw: Raw(usd: RawUsd(type: "", market: .cccagg, fromsymbol: "", tosymbol: .usd, flags: "", price: 0, median: 0, lastvolume: 0, lastvolumeto: 0, lasttradeid: "", volumeday: 0, volumedayto: 0, volume24Hour: 0, volume24Hourto: 0, openday: 0, highday: 0, lowday: 0, open24Hour: 0, high24Hour: 0, low24Hour: 0, lastmarket: "", volumehour: 0, volumehourto: 0, openhour: 0, highhour: 0, lowhour: 0, toptiervolume24Hour: 0, toptiervolume24Hourto: 0, change24Hour: 0, changepct24Hour: 0, changeday: 0, changepctday: 0, changehour: 0, changepcthour: 0, conversionsymbol: "", supply: 0, mktcap: 0, mktcappenalty: 0, totalvolume24H: 0, totalvolume24Hto: 0, totaltoptiervolume24H: 0, totaltoptiervolume24Hto: 0, imageurl: "")),
            display: Display(usd: DisplayUsd(fromsymbol: "", tosymbol: PurpleTOSYMBOL(rawValue: "$")!, market: PurpleMARKET(rawValue: "CryptoCompare Index")!, price: "", lastvolume: "", lastvolumeto: "", lasttradeid: "", volumeday: "", volumedayto: "", volume24Hour: "", volume24Hourto: "", openday: "", highday: "", lowday: "", open24Hour: "", high24Hour: "", low24Hour: "", lastmarket: "", volumehour: "", volumehourto: "", openhour: "", highhour: "", lowhour: "", toptiervolume24Hour: "", toptiervolume24Hourto: "", change24Hour: "", changepct24Hour: "", changeday: "", changepctday: "", changehour: "", changepcthour: "", conversionsymbol: "", supply: "", mktcap: "", mktcappenalty: Mktcappenalty(rawValue: "0 %")!, totalvolume24H: "", totalvolume24Hto: "", totaltoptiervolume24H: "", totaltoptiervolume24Hto: "", imageurl: "")))
    ]
    
    let mockNewsResponse = [
        NewsData(id: "", guid: "", publishedOn: 10, imageurl: "", title: "", url: "", source: "", body: "", tags: "", categories: "", upvotes: "", downvotes: "", lang: "", sourceInfo: .init(name: "", lang: "", img: ""))
    ]
    
    let errorResponse = ErrorResponse.apiError
    
    
    func fetchTopList(success: @escaping (CoinResponse) -> Void, failure: @escaping (ErrorResponse) -> Void) {
        if testScenario == .success {
            success(CoinResponse(message: "", type: 0, metaData: MetaData(count: 0), sponsoredData: [], data: mockCoinResponse, hasWarning: false))
        } else {
            failure(errorResponse)
        }
    }
    
    func fetchNews(success: @escaping (NewsResponse) -> Void, failure: @escaping (ErrorResponse) -> Void) {
        if testScenario == .success {
            success(NewsResponse(type: 0, message: "", data: mockNewsResponse, hasWarning: false))
        } else {
            failure(errorResponse)
        }
    }
}
