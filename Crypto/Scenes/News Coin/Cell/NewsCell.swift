//
//  NewsCell.swift
//  Crypto
//
//  Created by Tifo Audi Alif Putra on 03/06/21.
//

import UIKit

final class NewsCell: UITableViewCell {
    
    static let identifier: String = "NewsCellidentifier"
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
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
        
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [
                sourceLabel,
                titleLabel,
                bodyLabel
            ]
        )
        .setSpacing(6)
        .setAxis(.vertical)
        .setVerticalMargins(10)
        .setHorizontalMargins(16)
        
        contentView.addSubview(stackView)
        stackView.fillSuperview()
    }
    
    func bindViewWith(news: NewsData) {
        sourceLabel.text = news.source
        titleLabel.text = news.title
        bodyLabel.text = news.body
    }
    
}
