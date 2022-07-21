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
            let presentableCoins: [PresentableCoin] = coins.enumerated().map { (index: Int, coin: CoinData) in
                return PresentableCoin(
                    index: index,
                    name: coin.coinInfo.name,
                    fullname: coin.coinInfo.fullName,
                    symbol: coin.symbol,
                    price: coin.raw?.usd.price,
                    openDay: coin.raw?.usd.openday
                )
            }
            
            self?.viewController?.showCoins(data: presentableCoins)
        } failure: { [weak self] (error: ErrorResponse) in
            self?.viewController?.showErrorMessage(error: error)
        }
    }
    
    func didSelectCoin() {
        self.viewController?.onCoinSelected()
    }
}
