//
//  ViewController.swift
//  Crypto
//
//  Created by ruangguru on 01/06/21.
//

import UIKit

protocol TopListViewController: AnyObject {
    func showCoins(data: [CoinData])
    func showErrorMessage(error: ErrorResponse)
    func onCoinSelected()
}

final class DefaultTopListViewController: UITableViewController {
    
    private var coins: [CoinData] = []
    private var presenter: TopListPresenter
    
    init(presenter: TopListPresenter) {
        self.presenter = presenter
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchTopList()
        presenter.onViewStateChanged = { [weak self] in
            self?.tableView.reloadData()
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
        presenter.fetchTopList()
    }
}

extension DefaultTopListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter.state {
        case .error:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorStateCell.identifier, for: indexPath) as? ErrorStateCell else {
                return ErrorStateCell()
            }
            cell.reload = { [weak self] in
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
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.state == .populated ? coins.count : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.state == .populated ? 75 : tableView.bounds.height - 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard presenter.state == .populated else {
            return
        }
        
        presenter.didSelectCoin()
    }
}


extension DefaultTopListViewController: TopListViewController {
    func onCoinSelected() {
        
    }
    
    func showCoins(data: [CoinData]) {
        tableView.refreshControl?.endRefreshing()
        self.coins = data
        tableView.reloadData()
    }
    
    func showErrorMessage(error: ErrorResponse) {
        tableView.refreshControl?.endRefreshing()
        print(error.description)
    }
}
