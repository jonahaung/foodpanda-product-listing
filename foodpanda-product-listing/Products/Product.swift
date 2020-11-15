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
    
    func isValidStock() -> Bool {
        if stockAmount == -1 {
            return true
        }
        
        return stockAmount > 0
    }
    
    func isValidMaxOrder(for count: Int) -> Bool {
        if max_per_order == -1 {
            return true
        }
        return max_per_order >= count
    }
}
