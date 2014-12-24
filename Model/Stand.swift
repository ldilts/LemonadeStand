//
//  Stand.swift
//  LemonadeStand
//
//  Created by Lucas Michael Dilts on 12/19/14.
//  Copyright (c) 2014 Lucas Dilts. All rights reserved.
//

import Foundation
import UIKit

class Stand {
    var lemons: Int = 1
    var ice: Int = 1
    var balance: Double = 10.0
    
    var lemonade: Lemonade = Lemonade()
    var store: Store = Store()
    
    var lemonadeMix:(lemons:Int, ice:Int) = (0, 0)
    
    func Stand() {
        println("Hello")
    }
    
    func mixLemonade() {
        self.lemonade.mixLemonade(lemonadeMix)
    }
    
    func addLemon() {
        if self.lemons > 0 {
            self.lemonadeMix.lemons++
            self.lemons--
        }
    }
    
    func removeLemon() {
        if self.lemonadeMix.lemons > 0 {
            self.lemonadeMix.lemons--
            self.lemons++
        }
        // not enough lemons to remove!
    }
    
    func addIce() {
        if self.ice > 0 {
            self.lemonadeMix.ice++
            self.ice--
        }
    }
    
    func removeIce() {
        if self.lemonadeMix.ice > 0 {
            self.lemonadeMix.ice--
            self.ice++
        }
        // not enough ice to remove!
    }

    func isBalance() -> Bool {
        if balance < 0.0 {
            return false
        } else {
            return true
        }
    }
    
    func purchaseLemon() {
        let result = self.store.buyLemon(self.balance, lemons: self.lemons)
        self.setBalance(result.0)
        self.setLemons(result.1)
    }
    
    func purchaseIce() {
        let result = self.store.buyIce(self.balance, ice: self.ice)
        self.setBalance(result.0)
        self.setIce(result.1)
    }
    
    func returnLemon() {
        if self.lemons > 0 {
            let result = self.store.sellLemon(self.balance, lemons: self.lemons)
            self.setBalance(result.0)
            self.setLemons(result.1)
        } else {
            // not enough ice to return!
        }
    }
    
    func returnIce() {
        if self.ice > 0 {
            let result = self.store.sellIce(self.balance, ice: self.ice)
            self.setBalance(result.0)
            self.setIce(result.1)
        } else {
            // not enough ice to return!
        }
    }
    
    // Getters and Setters
    func getBalance() -> Double{
        return self.balance
    }
    
    func setBalance(balance: Double) {
        self.balance = balance
    }
    
    func getLemons() -> Int {
        return self.lemons
    }
    
    func setLemons(lemons: Int) {
        self.lemons = lemons
    }
    
    func getIce() -> Int {
        return self.ice
    }
    
    func setIce(ice: Int) {
        self.ice = ice
    }
    
}