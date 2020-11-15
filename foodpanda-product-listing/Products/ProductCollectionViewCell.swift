//
//  ProductCollectionViewCell.swift
//  foodpanda-product-listing
//
//  Created by Aung Ko Min on 15/11/20.
//  Copyright © 2020 foodpanda. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemsCountLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    private(set) var indexPath: IndexPath?
    
    weak var delegate: ProductCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBAction func didTapPlusButton(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        
               
        delegate?.productCollectionViewCell(self, didTapAdd: indexPath)
    }
    
    @IBAction func didTapMinusButton(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        
        delegate?.productCollectionViewCell(self, didTapMinusFor: indexPath)
    }
    
    func configure(_ product: Product, at indexPath: IndexPath, existing: [Product]) {
        self.indexPath = indexPath
        priceLabel.text = "S$\(product.price)"
        nameLabel.text = product.name.description
        itemsCountLabel.text = existing.count.description
        guard let url = URL(string: product.image_url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                if self?.indexPath == indexPath {
                    self?.imageView.image = image
                }
            }
        }.resume()
        
    }
}

// setup
extension ProductCollectionViewCell {
    private func setup() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layer.cornerRadius = 8
        imageView.layer.cornerRadius = 8
    }
}
