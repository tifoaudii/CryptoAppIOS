//
//  CryptoServiceTest.swift
//  CryptoTests
//
//  Created by Tifo Audi Alif Putra on 02/06/21.
//

@testable import Crypto
import XCTest

enum TestScenario {
    case success
    case failed
}

class CryptoServiceTest: XCTestCase {
    
    var sut: CryptoService!

    // MARK:- Test lifecycle
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    
    // MARK:- Testcase
    func testServiceFetchTopListCoins() {
        // Given
        let mockDataStore = MockNetworkDataStore(testScenario: .success)
        sut = CryptoService(dataStore: mockDataStore)
        
        // Then
        sut.fetchTopList { coins in
            XCTAssert(!coins.isEmpty)
        } failure: { _ in }
    }
    
    func testServiceFetchNews() {
        // Given
        let mockDataStore = MockNetworkDataStore(testScenario: .success)
        sut = CryptoService(dataStore: mockDataStore)
        
        // Then
        sut.fetchNews { news in
            XCTAssert(!news.isEmpty)
        } failure: { _ in }
    }

}
