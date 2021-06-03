//
//  CoinCell.swift
//  Crypto
//
//  Created by ruangguru on 02/06/21.
//

import UIKit

final class CoinCell: UITableViewCell {
    
    static let identifier: String = "CoinCellIdentifier"
    
    private lazy var HStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var coinCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var coinUpdateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
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
        contentView.addSubview(HStack)
        
        HStack
            .setVerticalMargins(8)
            .setHorizontalMargins(10)
            .fillSuperview()
        
        HStack.addArrangedSubview(
            UIStackView(
                arrangedSubviews: [
                    coinCodeLabel,
                    coinNameLabel
                ]
            )
            .setAxis(.vertical)
            .setDistribution(.fillProportionally)
        )
        
        HStack.addArrangedSubview(
            UIStackView(
                arrangedSubviews: [
                    coinPriceLabel,
                    coinUpdateLabel
                ]
            )
            .setAxis(.vertical)
            .setDistribution(.fillProportionally)
        )
    }
    
    func bindViewWith(coin: CoinData) {
        coinCodeLabel.text = coin.coinInfo.name
        coinNameLabel.text = coin.coinInfo.fullName
        
        let price: Double = coin.raw.usd.price
        let openDay: Double = coin.raw.usd.openday
        let updatePrice: Double = round((price - openDay) * 100) / 100
        let percentageUpdatePrice: Double = round((updatePrice / openDay) * 10000) / 100
        let symbolUpdate: String = (price < openDay) ? "" : "+"
        
        coinPriceLabel.text = "\(price)"
        coinUpdateLabel.text = "\(symbolUpdate)\(updatePrice)(\(percentageUpdatePrice)%)"
        coinUpdateLabel.backgroundColor = (price < openDay) ? .red : .systemGreen
    }
}
