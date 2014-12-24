//
//  Game.swift
//  LemonadeStand
//
//  Created by Lucas Michael Dilts on 12/24/14.
//  Copyright (c) 2014 Lucas Dilts. All rights reserved.
//

import Foundation
import UIKit

class Game {
    let lemonadeStand: Stand
    var customers: [Customer]
    var payingCustomers: Int = 0
    
    init(){
        self.lemonadeStand = Stand()
        self.customers = [Customer]()
        
        var randomNumber = 0
        while randomNumber == 0 {
            randomNumber = Int(arc4random_uniform(UInt32(11)))
        }
        
        for _ in 0..<randomNumber {
            var customer = Customer()
            self.customers.append(customer)
        }
    }
    
    func startDay() {
        self.lemonadeStand.mixLemonade()
        self.customers = []
        self.payingCustomers = 0
        
        var randomNumber = 0
        while randomNumber == 0 {
            randomNumber = Int(arc4random_uniform(UInt32(11)))
        }
        
        for _ in 0..<randomNumber {
            var customer = Customer()
            self.customers.append(customer)
        }
        
        println("\(self.customers.count)")
        
        var customerPreferenceRange = 0
        var lemonadeRange = 0
        
        println("Lemonade Ratio: " + "\(self.lemonadeStand.lemonade.lemonadeRatio)")
        if self.lemonadeStand.lemonade.lemonadeRatio < 1 {
            lemonadeRange = 2
        } else {
            if self.lemonadeStand.lemonade.lemonadeRatio == 1 {
                lemonadeRange = 1
            } else {
                if self.lemonadeStand.lemonade.lemonadeRatio > 1 {
                    lemonadeRange = 0
                } else {
                    println("Error!")
                }
            }
        }
        
        for customer in self.customers {
            println("Customer preference: " + "\(customer.preference)")
            if 0.0 <= customer.preference && customer.preference < 0.4 {
                customerPreferenceRange = 0
            } else {
                if 0.4 <= customer.preference && customer.preference < 0.7 {
                    customerPreferenceRange = 1
                } else {
                    if 0.7 <= customer.preference && customer.preference <= 1.0 {
                        customerPreferenceRange = 2
                    } else {
                        println("Error!")
                    }
                }
            }
            
            if customerPreferenceRange == lemonadeRange {
                self.lemonadeStand.balance += 1
                self.payingCustomers++
                println("Paid!")
            } else {
                println("Not paid...")
            }
            
            self.lemonadeStand.lemonadeMix.ice = 0
            self.lemonadeStand.lemonadeMix.lemons = 0
        }
        
    }
}