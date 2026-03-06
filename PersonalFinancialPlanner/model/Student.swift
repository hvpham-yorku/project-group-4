//
//  Student.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.Edited By Mehrshad Zarastounia
//

import Foundation
import Combine

// Represents a student in the UniWallet app
// ObservableObject allows SwiftUI views to update when data changes
final class Student: ObservableObject, Codable {
    
    // Unique identifier for the student
    var id: String
    
    // Student name
    var name: String
    
    // List of all income and expense transactions
    @Published var transactions: [Transaction]
    
    // Initializer
    init(id: String, name: String, transactions: [Transaction] = []) {
        self.id = id
        self.name = name
        self.transactions = transactions
    }
    
    // Adds a new transaction
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }
    
    // Calculates total income
    func totalIncome() -> Double {
        transactions
            .filter { $0.type == "Income" }
            .reduce(0) { $0 + $1.amount }
    }
    
    // Calculates total expenses
    func totalExpenses() -> Double {
        transactions
            .filter { $0.type == "Expense" }
            .reduce(0) { $0 + $1.amount }
    }
    
    // Calculates current balance
    func balance() -> Double {
        totalIncome() - totalExpenses()
    }
    
    // Groups expenses by category
    func expensesByCategory() -> [String: Double] {
        var result: [String: Double] = [:]
        
        for transaction in transactions where transaction.type == "Expense" {
            result[transaction.category, default: 0] += transaction.amount
        }
        
        return result
    }
    
    // MARK: - Codable Support
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case transactions
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        transactions = try container.decode([Transaction].self, forKey: .transactions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(transactions, forKey: .transactions)
    }
}
