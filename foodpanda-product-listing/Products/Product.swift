//
//  Product.swift
//  foodpanda-product-listing
//
//  Created by Aung Ko Min on 15/11/20.
//  Copyright © 2020 foodpanda. All rights reserved.
//

import Foundation

class Product: Codable {
    var id: Int
    var name: String
    var price: Int
    var image_url: String
    var stockAmount: Int
    var max_per_order: Int
    
}
extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

// Validating
extension Product {
    
    private func isValidStock() -> Bool {
        if stockAmount == -1 {
            return true
        }
        return stockAmount > 0
    }
    
    private func isValidMaxOrder(for count: Int) -> Bool {
        if max_per_order == -1 {
            return true
        }
        return max_per_order >= count
    }
    
    func addToCart(for existingCount: Int) throws  {
        
        guard isValidStock() else { throw ProductError.outOfStock }
        guard isValidMaxOrder(for: existingCount) else { throw ProductError.maxItemsReached }
        if stockAmount != -1 {
            stockAmount -= 1
        }
    }
    
    func removeFromCart(with productsInCart: [Product]) throws -> [Product] {
        var existings = productsInCart
        guard let i = existings.firstIndex(of: self) else { throw ProductError.failToRemoveFromCart }
        existings.remove(at: i)
        if stockAmount != -1 {
            stockAmount += 1
        }
        return existings
    }
    
}
