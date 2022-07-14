//
//  DefaultNewsViewController.swift
//  Crypto
//
//  Created by Tifo Audi Alif Putra on 02/06/21.
//

import UIKit

protocol NewsViewController: AnyObject {
    func showNews(news: [NewsData])
    func showError(error: ErrorResponse)
}

final class DefaultNewsViewController: UITableViewController {
    
    private var news: [NewsData] = []
    private let presenter: NewsPresenter
    
    init(presenter: NewsPresenter) {
        self.presenter = presenter
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private(set) var state: ViewState = .request {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchNews()
    }
    
    private func configureTableView() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        tableView.register(ErrorStateCell.self, forCellReuseIdentifier: ErrorStateCell.identifier)
        tableView.register(RequestStateCell.self, forCellReuseIdentifier: RequestStateCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
        tableView.tableFooterView = UIView()
    }
}

extension DefaultNewsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .error:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorStateCell.identifier, for: indexPath) as? ErrorStateCell else {
                return ErrorStateCell()
            }
            cell.reload = { [weak self] in
                self?.state = .request
                self?.presenter.fetchNews()
            }
            return cell
        case .populated:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
                return NewsCell()
            }
            
            cell.bindViewWith(news: news[indexPath.row])
            return cell
        case .request:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestStateCell.identifier, for: indexPath) as? RequestStateCell else {
                return RequestStateCell()
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state == .populated ? news.count : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return state == .populated ? UITableView.automaticDimension : tableView.bounds.height - 50
    }
    
}

extension DefaultNewsViewController: NewsViewController {
    func showNews(news: [NewsData]) {
        print(news)
        self.news = news
        state = .populated
    }
    
    func showError(error: ErrorResponse) {
        state = .error
        print(error)
    }
}

