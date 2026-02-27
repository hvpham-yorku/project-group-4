//
//  Transaction.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//

import Foundation

// Represents a single transaction in UniWallet
// Can be either income or expense
class Transaction {
    
    // Unique identifier for the transaction
    var id: String
    
    // Amount of money for this transaction
    var amount: Double
    
    // Date when the transaction occurred
    var date: Date
    
    // Type of transaction: "Income" or "Expense"
    var type: String
    
    // Category of transaction (e.g., "Food", "Salary", "Transport")
    var category: String

    // Initializer for creating a transaction with all required fields
    init(id: String, amount: Double, date: Date, type: String, category: String) {
        self.id = id
        self.amount = amount
        self.date = date
        self.type = type
        self.category = category
    }
}
