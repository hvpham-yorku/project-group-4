//
//  Transaction.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.Edited by Mehrshad Zarastounia
//

import Foundation

// Represents one income or expense transaction
final class Transaction: Codable {
    
    // Unique identifier
    var id: String
    
    // Transaction amount
    var amount: Double
    
    // Transaction date
    var date: Date
    
    // Transaction type: Income or Expense
    var type: String
    
    // Transaction category/title
    var category: String
    
    init(id: String, amount: Double, date: Date, type: String, category: String) {
        self.id = id
        self.amount = amount
        self.date = date
        self.type = type
        self.category = category
    }
}
