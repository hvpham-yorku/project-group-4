//
//  Account.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//
import Foundation

// Represents a financial account in UniWallet (e.g., bank account, cash, card)
class Account {
    
    // Unique identifier for the account
    var id: String
    
    // Type of account (e.g., "Checking", "Savings", "Cash")
    var type: String
    
    // Current balance of the account
    var balance: Double

    // Initializer for creating a new account
    init(id: String, type: String, balance: Double) {
        self.id = id
        self.type = type
        self.balance = balance
    }
}
