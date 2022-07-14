//
//  TopListPresenter.swift
//  Crypto
//
//  Created by Tifo Audi Alif Putra on 02/06/21.
//

import Foundation

protocol TopListPresenter {
    func fetchTopList()
    func didSelectCoin()
}

final class DefaultTopListPresenter: TopListPresenter {
    
    private weak var viewController: TopListViewController?
    private let service: CryptoService
    
    init(service: CryptoService) {
        self.service = service
    }
    
    func setViewController(_ viewController: TopListViewController) {
        self.viewController = viewController
    }
    
    func fetchTopList() {
        service.fetchTopList { [weak self] (coins: [CoinData]) in
            self?.viewController?.showCoins(data: coins)
        } failure: { [weak self] (error: ErrorResponse) in
            self?.viewController?.showErrorMessage(error: error)
        }
    }
    
    func didSelectCoin() {
        self.viewController?.onCoinSelected()
    }
}
