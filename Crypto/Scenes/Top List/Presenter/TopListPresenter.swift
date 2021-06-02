//
//  TopListPresenter.swift
//  Crypto
//
//  Created by ruangguru on 02/06/21.
//

import Foundation

protocol TopListPresenter {
    var state: ViewState { get }
    var onViewStateChanged: (() -> Void)? { get set }
    
    func fetchTopList()
    func didSelectCoin()
}

final class DefaultTopListPresenter: TopListPresenter {
    
    private weak var viewController: TopListViewController?
    private let service: CryptoService
    
    private var viewState: ViewState = .initial {
        didSet {
            onViewStateChanged?()
        }
    }
    
    var onViewStateChanged: (() -> Void)?
    
    init(service: CryptoService) {
        self.service = service
    }
    
    func setViewController(_ viewController: TopListViewController) {
        self.viewController = viewController
    }
    
    var state: ViewState {
        viewState
    }
    
    func fetchTopList() {
        viewState = .request
        service.fetchTopList { [weak self] (coins: [CoinData]) in
            self?.viewState = .populated
            self?.viewController?.showCoins(data: coins)
        } failure: { [weak self] (error: ErrorResponse) in
            self?.viewState = .error
            self?.viewController?.showErrorMessage(error: error)
        }
    }
    
    func didSelectCoin() {
        self.viewController?.onCoinSelected()
    }
}
