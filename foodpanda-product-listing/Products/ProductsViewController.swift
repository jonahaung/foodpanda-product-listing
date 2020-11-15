//
//  ViewController.swift
//  foodpanda-product-listing
//
//  Created by Shahin Gharebaghi on 27/10/20.
//  Copyright © 2020 foodpanda. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footerCardView: UIView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    private var products = [Product]()
    private var selectedItems = [Product]() {
        didSet {
            updateCard()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchData()
    }

}

// Set up
extension ProductsViewController {
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        footerCardView.layer.cornerRadius = 8
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(5)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 100, trailing: 5)
        section.interGroupSpacing = 5
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func fetchData() {
        if let url = Bundle.main.url(forResource: "products", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                products = (try decoder.decode([Product].self, from: data)).filter{$0.stockAmount != 0}
            } catch {
                print("error:\(error)")
            }
        }
    }
}

// Datasource / Delegate
extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.item]
        cell.configure(product, at: indexPath, existing: selectedItems.filter{ $0 == product })
        cell.delegate = self
        return cell
    }
}


extension ProductsViewController: ProductCollectionViewCellDelegate, AlertPresenting {
    
    // Plus
    func productCollectionViewCell(_ cell: ProductCollectionViewCell, didTapAdd indexPath: IndexPath) {
        
        let product = products[indexPath.item]
        let existings = selectedItems.filter{ $0 == product }
        let count = existings.count + 1
        
        guard product.isValidMaxOrder(for: count) else {
            showAlert(title: "Max order reached", message: "User should not be able to add more than max_per_order")
            return
        }
        guard product.isValidStock() else {
            showAlert(title: "Out of stock", message: "User should not be able to add more than stock_amount")
            return
        }
        if product.stockAmount != -1 {
            product.stockAmount -= 1
        }
        UIDevice.playTock()
        selectedItems.append(product)
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell {
            cell.itemsCountLabel.text = count.description
        }
    
    }
    
    // Minus
    func productCollectionViewCell(_ cell: ProductCollectionViewCell, didTapMinusFor indexPath: IndexPath) {
        let product = products[indexPath.item]
        if let i = selectedItems.firstIndex(of: product) {
            selectedItems.remove(at: i)
            if product.stockAmount != -1 {
                product.stockAmount += 1
            }
            UIDevice.playTock()
            let existings = selectedItems.filter{ $0 == product }
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell {
                cell.itemsCountLabel.text = existings.count.description
            }
        }
    }
    
    private func updateCard() {
        footerCardView.isHidden = selectedItems.isEmpty
        let totalPrice = selectedItems.map{ $0.price }.reduce(0){$0 + $1 }
        let totalItem = selectedItems.count
        totalItemsLabel.text = "\(totalItem) items"
        totalPriceLabel.text = "$\(totalPrice)"
    }
}
