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
    internal var selectedItems = [Product]() {
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
        collectionView.setCollectionViewLayout(createGridLayout(), animated: false)
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
                showAlert(title: "Error", message: error.localizedDescription)
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
        cell.delegate = self
        cell.configure(product, at: indexPath)
        return cell
    }
}

// ProductCell Delegate
extension ProductsViewController: ProductCollectionViewCellDelegate, AlertPresenting {
    
    // Add to Cart
    func productCollectionViewCell(_ cell: ProductCollectionViewCell, didTapAdd indexPath: IndexPath) {
        
        let product = products[indexPath.item]
        let existings = selectedItems.filter{ $0 == product }
        let existingCount = existings.count + 1
        
        do {
            try product.addToCart(for: existingCount)
            
            UIDevice.playTock()
            selectedItems.append(product)
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell {
                cell.itemsCountLabel.text = existingCount.description
                Vibration.light.vibrate()
            }
        }catch {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    // Remove from Cart
    func productCollectionViewCell(_ cell: ProductCollectionViewCell, didTapMinusFor indexPath: IndexPath) {
        let product = products[indexPath.item]
        do {
            selectedItems = try product.removeFromCart(with: selectedItems)
            UIDevice.playTock()
            let existings = selectedItems.filter{ $0 == product }
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell {
                cell.itemsCountLabel.text = existings.count.description
                Vibration.light.vibrate()
            }
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
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
