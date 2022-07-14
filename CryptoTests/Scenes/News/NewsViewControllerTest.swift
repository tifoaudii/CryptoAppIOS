//
//  NewsViewControllerTest.swift
//  CryptoTests
//
//  Created by Tifo Audi Alif Putra on 03/06/21.
//

@testable import Crypto
import XCTest

class NewsViewControllerTest: XCTestCase {

    var sut: DefaultNewsViewController!
    var window: UIWindow!
    

    // MARK:- Test lifecycles
    override func setUpWithError() throws {
        window = UIWindow()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        window = nil
        try super.tearDownWithError()
    }
    
    // MARK:- Private
    
    private func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK:- Mock
    class NewsPresenterMock: NewsPresenter {
        
        var fetchNewsCalled = false
        
        func fetchNews() {
            fetchNewsCalled = true
        }
    }
    
    // MARK:- Testcase
    
    func testViewControllerStateShouldEqualToRequestWhenViewDidLoaded() {
        // Given
        let mockPresenter = NewsPresenterMock()
        sut = DefaultNewsViewController(presenter: mockPresenter)
        
        // When
        loadView()
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.state, .request)
    }
    
    func testViewControllerStateShouldEqualToPopulated() {
        // Given
        let mockPresenter = NewsPresenterMock()
        sut = DefaultNewsViewController(presenter: mockPresenter)
        
        // When
        loadView()
        sut.showNews(news: [])
        
        // Then
        XCTAssertEqual(sut.state, .populated)
    }
    
    func testViewControllerStateShouldEqualToError() {
        // Given
        let mockPresenter = NewsPresenterMock()
        sut = DefaultNewsViewController(presenter: mockPresenter)
        
        // When
        loadView()
        sut.showError(error: .apiError)
        
        // Then
        XCTAssertEqual(sut.state, .error)
    }
    
    func testViewControllerShouldAskPresenterToFetchTopListCoins() {
        // Given
        let mockPresenter = NewsPresenterMock()
        sut = DefaultNewsViewController(presenter: mockPresenter)
        
        // When
        loadView()
        sut.viewWillAppear(true)
        
        // Then
        XCTAssert(mockPresenter.fetchNewsCalled)
    }

}
