//
//  Extensions.swift
//  foodpanda-product-listing
//
//  Created by Aung Ko Min on 15/11/20.
//  Copyright © 2020 foodpanda. All rights reserved.
//

import UIKit
import AudioToolbox

extension UIDevice {
    
    class func playTock() {
        AudioServicesPlaySystemSound(1105)
    }
}
