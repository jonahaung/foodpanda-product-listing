//
//  ProductValidationTest.swift
//  foodpanda-product-listingTests
//
//  Created by Aung Ko Min on 16/11/20.
//  Copyright © 2020 foodpanda. All rights reserved.
//

@testable import foodpanda_product_listing
import XCTest

class ProductValidationTest: XCTestCase {

    var product: Product!
    
    override func setUp() {
        super.setUp()
        product = Product(_id: 1, _name: "Cheese Cake", _price: 20, _image_url: "https://cdn.shopify.com/s/files/1/0248/2411/9343/products/Pepperoni_1024x1024.png?v=1574684715", _stockAmount: 2, _max_per_order: 2)
    }
    
    override func tearDown() {
        super.tearDown()
        product = nil
    }
    
    func test_add_to_cart() throws {
        XCTAssertNoThrow(try product.addToCart(for: 2))
    }

}
