//
//  PresentableCoin.swift
//  Crypto
//
//  Created by Tifo Audi Alif Putra on 15/07/22.
//

import Foundation

final class PresentableCoin {
    
    let index: Int
    let symbol: String
    let name: String
    let fullname: String
    let openDay: Double
    
    private(set) var price: Double
    
    init(index: Int, name: String, fullname: String, symbol: String, price: Double?, openDay: Double?) {
        self.index = index
        self.symbol = symbol
        self.name = name
        self.fullname = fullname
        self.price = price ?? 0
        self.openDay = openDay ?? 0
    }
    

    func makePresentableUpdatedCoin() -> String {
        let updatedPrice: Double = round((price - openDay) * 100) / 100
        let percentageUpdatedPrice: Double = round((updatedPrice / openDay) * 10000) / 100
        let symbolUpdate: String = price < openDay ? "" : "+"
        return "\(symbolUpdate)\(updatedPrice)(\(percentageUpdatedPrice)%)"
    }
    
    func updatePrice(_ price: Double) {
        self.price = price
    }
}

