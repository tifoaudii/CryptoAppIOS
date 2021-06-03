//
//  NewsPresenter.swift
//  Crypto
//
//  Created by ruangguru on 02/06/21.
//

import Foundation

protocol NewsPresenter {
    func fetchNews()
}

final class DefaultNewsPresenter: NewsPresenter {
    
    private weak var viewController: NewsViewController?
    private let service: CryptoService
    
    init(service: CryptoService) {
        self.service = service
    }
    
    func setViewController(_ viewController: NewsViewController) {
        self.viewController = viewController
    }
    
    func fetchNews() {
        service.fetchNews { [weak self] (news: [NewsData]) in
            self?.viewController?.showNews(news: news)
        } failure: { [weak self] (error: ErrorResponse) in
            self?.viewController?.showError(error: error)
        }
    }
}
