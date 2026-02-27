//
//  Budget.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//
import Foundation

// Represents a budget for a specific category in UniWallet
class Budget {
    
    // The category of spending this budget applies to (e.g., "Food", "Transport")
    var category: String
    
    // Maximum allowed spending for this category
    var limit: Double

    // Initializer to create a budget with a category and limit
    init(category: String, limit: Double) {
        self.category = category
        self.limit = limit
    }

    // Calculate remaining budget given the amount already spent
    func remaining(spent: Double) -> Double {
        limit - spent
    }
}
