//
//  ViewController.swift
//  Crypto
//
//  Created by Tifo Audi Alif Putra on 01/06/21.
//

import UIKit

protocol TopListViewController: AnyObject {
    func showCoins(data: [PresentableCoin])
    func showErrorMessage(error: ErrorResponse)
    func onCoinSelected()
}

final class DefaultTopListViewController: UITableViewController, URLSessionWebSocketDelegate {
    
    private var coins: [PresentableCoin] = []
    private let presenter: TopListPresenter
    private let coinListener: LiveCoinListener
    
    private var socket: URLSessionWebSocketTask?
    
    private(set) var state: ViewState = .request {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(presenter: TopListPresenter, coinListener: LiveCoinListener) {
        self.presenter = presenter
        self.coinListener = coinListener
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crypto"
        configureTableView()
        configureCoinListener()
    }
    
    private func configureCoinListener() {
        coinListener.connect()
        coinListener.onListen()
        coinListener.newData = { [weak self] price, symbol in
            guard let self = self else { return }
            self.updateCoin(newPrice: price, from: symbol)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchTopList()
    }
    
    func updateCoin(newPrice: Double, from symbol: String) {
        if let updatedIndex = self.coins.firstIndex(where: { $0.name == symbol }) {
            let coin = self.coins[updatedIndex]
            coin.updatePrice(newPrice)
            
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [.init(row: updatedIndex, section: 0)], with: .fade)
            }
        }
    }
    
    func sendRequest() {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            let coinSymbols = visibleIndexPaths.map {
                self.coins[$0.row].symbol
            }
            
            coinListener.send(coinSymbols)
        }
    }
    
    private func configureTableView() {
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        tableView.register(ErrorStateCell.self, forCellReuseIdentifier: ErrorStateCell.identifier)
        tableView.register(RequestStateCell.self, forCellReuseIdentifier: RequestStateCell.identifier)
        tableView.refreshControl = createRefreshControl()
        tableView.tableFooterView = UIView()
    }
    
    private func createRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefreshControlHandled), for: .valueChanged)
        return refreshControl
    }
    
    @objc private func onRefreshControlHandled() {
        state = .request
        presenter.fetchTopList()
    }
}

extension DefaultTopListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .error:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorStateCell.identifier, for: indexPath) as? ErrorStateCell else {
                return ErrorStateCell()
            }
            cell.reload = { [weak self] in
                self?.state = .request
                self?.presenter.fetchTopList()
            }
            return cell
        case .populated:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell else {
                return CoinCell()
            }
            
            cell.bindViewWith(coin: coins[indexPath.row])
            return cell
        case .request:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestStateCell.identifier, for: indexPath) as? RequestStateCell else {
                return RequestStateCell()
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state == .populated ? coins.count : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return state == .populated ? 75 : tableView.bounds.height - 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard state == .populated else {
            return
        }
        
        presenter.didSelectCoin()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        coinListener.cancel()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            coinListener.resume()
            sendRequest()
            coinListener.onListen()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        coinListener.resume()
        sendRequest()
        coinListener.onListen()
    }
}


extension DefaultTopListViewController: TopListViewController {
    func onCoinSelected() {
        let service = CryptoService(dataStore: URLSessionDataStore())
        let presenter = DefaultNewsPresenter(service: service)
        let newsViewController = DefaultNewsViewController(presenter: presenter)
        presenter.setViewController(newsViewController)
        present(newsViewController, animated: true, completion: nil)
    }
    
    func showCoins(data: [PresentableCoin]) {
        tableView.refreshControl?.endRefreshing()
        self.coins = data
        self.state = .populated
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.sendRequest()
        }
    }
    
    func showErrorMessage(error: ErrorResponse) {
        tableView.refreshControl?.endRefreshing()
        self.state = .error
    }
}
