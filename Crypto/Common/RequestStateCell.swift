//
//  RequestStateCell.swift
//  Crypto
//
//  Created by ruangguru on 02/06/21.
//

import UIKit

final class RequestStateCell: UITableViewCell {
    
    static let identifier: String = "RequestStateCellIdentifier"
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
    }
    
    private func configureCell() {
        selectionStyle = .none
        contentView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        spinner.startAnimating()
    }
    
}
