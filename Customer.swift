//
//  Customer.swift
//  LemonadeStand
//
//  Created by Lucas Michael Dilts on 12/24/14.
//  Copyright (c) 2014 Lucas Dilts. All rights reserved.
//

import Foundation
import UIKit

class Customer {
    let preference: Double = 0.0
    
    init() {
//        A random number between 0 and 10
        var randomNumber = Int(arc4random_uniform(UInt32(11)))
//        A random number between 0 and 1
        var preference: Double = Double(randomNumber)/10.0
        self.preference = preference
    }
}