//
//  ProductCollectionViewCellDelegate.swift
//  foodpanda-product-listing
//
//  Created by Aung Ko Min on 15/11/20.
//  Copyright © 2020 foodpanda. All rights reserved.
//

import Foundation
protocol ProductCollectionViewCellDelegate: class {
    func productCollectionViewCell(_ cell: ProductCollectionViewCell, didTapAdd indexPath: IndexPath)
    func productCollectionViewCell(_ cell: ProductCollectionViewCell, didTapMinusFor indexPath: IndexPath)
}
