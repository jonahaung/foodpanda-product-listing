//
//  AlertPresenting.swift
//  foodpanda-product-listing
//
//  Created by Aung Ko Min on 15/11/20.
//  Copyright © 2020 foodpanda. All rights reserved.
//

import UIKit

protocol AlertPresenting {
    
}

extension AlertPresenting {
    func showAlert(title: String?, message: String?) {
        let x = UIAlertController(title: title, message: message, preferredStyle: .alert)
        x.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            SceneDelegate.delegate?.window?.rootViewController?.present(x, animated: true, completion: nil)
            Vibration.error.vibrate()
        }
    }
}

