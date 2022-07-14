//
//  NewsPresenterTest.swift
//  CryptoTests
//
//  Created by Tifo Audi Alif Putra on 03/06/21.
//

@testable import Crypto
import XCTest

class NewsPresenterTest: XCTestCase {

    // MARK:- System under test
    
    var sut: DefaultNewsPresenter!

    // MARK:- Test lifecycle
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK:- Mock
    
    class NewsViewControllerMock: NewsViewController {
        
        var showNewsCalled = false
        var showErrorCalled = false
        
        func showNews(news: [NewsData]) {
            showNewsCalled = true
        }
        
        func showError(error: ErrorResponse) {
            showErrorCalled = true
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
        
        var fetchNewsCalled = false
        
        override func fetchNews(success: @escaping ([NewsData]) -> Void, failure: @escaping (ErrorResponse) -> Void) {
            fetchNewsCalled = true
            
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
        sut = DefaultNewsPresenter(service: mockService)
        
        // When
        sut.fetchNews()
        
        // Then
        XCTAssert(mockService.fetchNewsCalled)
    }
    
    func testPresenterShouldViewControllerToShowCoins() {
        // Given
        let mockViewController = NewsViewControllerMock()
        let mockService = MockCryptoService(testScenario: .success)
        sut = DefaultNewsPresenter(service: mockService)
        sut.setViewController(mockViewController)
        
        // When
        sut.fetchNews()
        
        // Then
        XCTAssert(mockViewController.showNewsCalled)
    }
    
    func testPresenterShouldAskViewControllerToShowError() {
        // Given
        let mockViewController = NewsViewControllerMock()
        let mockService = MockCryptoService(testScenario: .failed)
        sut = DefaultNewsPresenter(service: mockService)
        sut.setViewController(mockViewController)
        
        // When
        sut.fetchNews()
        
        // Then
        XCTAssert(mockViewController.showErrorCalled)
    }
}
