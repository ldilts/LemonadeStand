//
//  Store.swift
//  LemonadeStand
//
//  Created by Lucas Michael Dilts on 12/19/14.
//  Copyright (c) 2014 Lucas Dilts. All rights reserved.
//

import Foundation
import UIKit

class Store {
    let lemonCost: Double = 2.0
    let iceCost: Double = 1.0
    
    func buyLemon(balance: Double, lemons: Int) -> (Double, Int) {
        return (balance - self.lemonCost, lemons + 1)
    }
    
    func buyIce(balance: Double, ice: Int) -> (Double, Int) {
        return (balance - self.iceCost, ice + 1)
    }
    
    func sellLemon(balance: Double, lemons: Int) -> (Double, Int) {
        return (balance + self.lemonCost, lemons - 1)
    }
    
    func sellIce(balance: Double, ice: Int) -> (Double, Int) {
        return (balance + self.iceCost, ice - 1)
    }
}