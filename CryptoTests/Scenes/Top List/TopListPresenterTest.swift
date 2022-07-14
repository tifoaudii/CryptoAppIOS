//
//  TopListPresenterTest.swift
//  CryptoTests
//
//  Created by Tifo Audi Alif Putra on 02/06/21.
//

@testable import Crypto
import XCTest



class TopListPresenterTest: XCTestCase {

    // MARK:- System under test
    
    var sut: DefaultTopListPresenter!

    // MARK:- Test lifecycle
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK:- Mock
    
    class TopListViewControllerMock: TopListViewController {
        
        var showCoinsCalled = false
        var showErrorMessageCalled = false
        var onCoinSelectedCalled = false
        
        func showCoins(data: [CoinData]) {
            showCoinsCalled = true
        }
        
        func showErrorMessage(error: ErrorResponse) {
            showErrorMessageCalled = true
        }
        
        func onCoinSelected() {
            onCoinSelectedCalled = true
        }
    }
    
    class MockCryptoService: CryptoService {
        private let testScenario: TestScenario
        
        init(testScenario: TestScenario) {
            self.testScenario = testScenario
            super.init(
                dataStore: MockNetworkDataStore(
                    testScenario: testScenario
                )
            )
        }
        
        var fetchTopListCalled = false
        
        override func fetchTopList(success: @escaping ([CoinData]) -> Void, failure: @escaping (ErrorResponse) -> Void) {
            fetchTopListCalled = true
            
            if testScenario == .success {
                success([])
            } else {
                failure(.apiError)
            }
        }
    }
    
    
    // MARK:- Testcases
    
    func testPresenterShouldAskServiceToFetchTopList() {
        // Given
        let mockService = MockCryptoService(testScenario: .success)
        sut = DefaultTopListPresenter(service: mockService)
        
        // When
        sut.fetchTopList()
        
        // Then
        XCTAssert(mockService.fetchTopListCalled)
    }
    
    func testPresenterShouldViewControllerToShowCoins() {
        // Given
        let mockViewController = TopListViewControllerMock()
        let mockService = MockCryptoService(testScenario: .success)
        sut = DefaultTopListPresenter(service: mockService)
        sut.setViewController(mockViewController)
        
        // When
        sut.fetchTopList()
        
        // Then
        XCTAssert(mockViewController.showCoinsCalled)
    }
    
    func testPresenterShouldAskViewControllerToShowError() {
        // Given
        let mockViewController = TopListViewControllerMock()
        let mockService = MockCryptoService(testScenario: .failed)
        sut = DefaultTopListPresenter(service: mockService)
        sut.setViewController(mockViewController)
        
        // When
        sut.fetchTopList()
        
        // Then
        XCTAssert(mockViewController.showErrorMessageCalled)
    }
    
    func testPresenterShouldAskViewControllerWhenCoinSelected() {
        // Given
        let mockViewController = TopListViewControllerMock()
        let mockService = MockCryptoService(testScenario: .failed)
        sut = DefaultTopListPresenter(service: mockService)
        sut.setViewController(mockViewController)
        
        // When
        sut.didSelectCoin()
        
        // Then
        XCTAssert(mockViewController.onCoinSelectedCalled)
    }
}
