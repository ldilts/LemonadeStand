//
//  Lemonade.swift
//  LemonadeStand
//
//  Created by Lucas Michael Dilts on 12/24/14.
//  Copyright (c) 2014 Lucas Dilts. All rights reserved.
//

import Foundation
import UIKit

class Lemonade {
    var lemons: Int = 0
    var ice: Int = 0
    var lemonadeRatio: Double = 0.0
    
    func mixLemonade(lemonadeMix:(lemons:Int, ice:Int)) {
        self.lemons = lemonadeMix.lemons
        self.ice = lemonadeMix.ice
        
        if self.ice > 0 {
            self.lemonadeRatio = (Double(self.lemons)/Double(self.ice))
        } else {
            lemonadeRatio = 1.0
        }
        
    }
    
//    // Getters and Setters
//    func getLemons() -> Int {
//        return self.lemons
//    }
//    
//    func setLemons(lemons: Int) {
//        self.lemons = lemons
//    }
//    
//    func getIce() -> Int {
//        return self.ice
//    }
//    
//    func setIce(ice: Int) {
//        self.ice = ice
//    }
// 
    func getLemonadeRatio() -> Double {
        return self.lemonadeRatio
    }
}
