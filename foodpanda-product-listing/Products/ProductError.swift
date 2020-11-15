//
//  ProductError.swift
//  foodpanda-product-listing
//
//  Created by Aung Ko Min on 16/11/20.
//  Copyright © 2020 foodpanda. All rights reserved.
//

import Foundation

enum ProductError: LocalizedError {
    
    case outOfStock, maxItemsReached, failToRemoveFromCart
    
    var errorDescription: String? {
        switch self {
        case .outOfStock:
            return "Out of stock. You cannot add more than stock_amount"
        case .maxItemsReached:
            return "Max order reached. You cannont add more than max_per_order"
        case .failToRemoveFromCart:
            return "Failed to remove from cart"
        }
    }
}
