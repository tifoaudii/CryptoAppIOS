//
//  TopListViewControllerTest.swift
//  CryptoTests
//
//  Created by ruangguru on 02/06/21.
//

@testable import Crypto
import XCTest

class TopListViewControllerTest: XCTestCase {
    
    var sut: DefaultTopListViewController!
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
    class TopListPresenterMock: TopListPresenter {
        
        var fetchTopListCalled = false
        var didSelectCoinCalled = false
        
        func fetchTopList() {
            fetchTopListCalled = true
        }
        
        func didSelectCoin() {
            didSelectCoinCalled = true
        }
    }
    
    // MARK:- Testcase
    
    func testViewControllerStateShouldEqualToRequestWhenViewDidLoaded() {
        // Given
        let mockPresenter = TopListPresenterMock()
        sut = DefaultTopListViewController(presenter: mockPresenter)
        
        // When
        loadView()
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.state, .request)
    }
    
    func testViewControllerStateShouldEqualToPopulated() {
        // Given
        let mockPresenter = TopListPresenterMock()
        sut = DefaultTopListViewController(presenter: mockPresenter)
        
        // When
        loadView()
        sut.showCoins(data: [])
        
        // Then
        XCTAssertEqual(sut.state, .populated)
    }
    
    func testViewControllerStateShouldEqualToError() {
        // Given
        let mockPresenter = TopListPresenterMock()
        sut = DefaultTopListViewController(presenter: mockPresenter)
        
        // When
        loadView()
        sut.showErrorMessage(error: .apiError)
        
        // Then
        XCTAssertEqual(sut.state, .error)
    }
    
    func testViewControllerShouldAskPresenterToFetchTopListCoins() {
        // Given
        let mockPresenter = TopListPresenterMock()
        sut = DefaultTopListViewController(presenter: mockPresenter)
        
        // When
        loadView()
        sut.viewWillAppear(true)
        
        // Then
        XCTAssert(mockPresenter.fetchTopListCalled)
    }
}
