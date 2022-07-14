//
//  ViewController.swift
//  Crypto
//
//  Created by Tifo Audi Alif Putra on 01/06/21.
//

import UIKit

protocol TopListViewController: AnyObject {
    func showCoins(data: [CoinData])
    func showErrorMessage(error: ErrorResponse)
    func onCoinSelected()
}

final class DefaultTopListViewController: UITableViewController, URLSessionWebSocketDelegate {
    
    private var coins: [CoinData] = []
    private let presenter: TopListPresenter
    
    private var socket: URLSessionWebSocketTask?
    
    private(set) var state: ViewState = .request {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        title = "Crypto"
        
        let streamURL: URL = .init(string: "wss://streamer.cryptocompare.com/v2?api_key=4c6ec4fa84b66963743a2a2ea291ec5e6216fe1c5453046f3b16c186878743b5")!
        socket = URLSession(configuration: .default, delegate: self, delegateQueue: .init()).webSocketTask(with: streamURL)
        socket?.resume()
        
        listen()
    }
    
    func listen() {
        socket?.receive(completionHandler: { result in
            switch result {
            case .success(let data):
                print("DATA RECEIVED \(data)")
                self.listen()
            case .failure(let error):
                print("ERRORRRR \(error)")
            }
        })
    }
    
    func send(_ request: Data) {
        socket?.send(.data(request), completionHandler: { (error: Error?) in
            if error == nil { }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchTopList()
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
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
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
            
            if indexPath.row == 0 {
                
                let subRequest: [String : Any] = [
                    "action": "SubAdd",
                    "subs": [coins[0].symbol]
                ]
                
                let data = try! JSONEncoder().encode(SubRequest(subs: [coins[0].symbol]))
                send(data)
            }
            
            return cell
        case .request:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestStateCell.identifier, for: indexPath) as? RequestStateCell else {
                return RequestStateCell()
            }
            
            return cell
        }
    }
    
    func dictToJson<T: Encodable>(_ dict: [String : T]) -> Data {
        try! JSONEncoder().encode(dict)
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
}


extension DefaultTopListViewController: TopListViewController {
    func onCoinSelected() {
        let service = CryptoService(dataStore: DefautNetworkDataStore())
        let presenter = DefaultNewsPresenter(service: service)
        let newsViewController = DefaultNewsViewController(presenter: presenter)
        presenter.setViewController(newsViewController)
        present(newsViewController, animated: true, completion: nil)
    }
    
    func showCoins(data: [CoinData]) {
        tableView.refreshControl?.endRefreshing()
        self.coins = data
        self.state = .populated
    }
    
    func showErrorMessage(error: ErrorResponse) {
        tableView.refreshControl?.endRefreshing()
        self.state = .error
        print(error.description)
    }
}

struct SubRequest: Encodable {
    let action = "SubAdd"
    let subs: [String]
}
