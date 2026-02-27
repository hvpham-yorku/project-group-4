//
//  Student.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//
import Foundation
import Combine

// Represents a student in the UniWallet app
// ObservableObject allows SwiftUI views to automatically update when @Published properties change
class Student: ObservableObject {
    
    // Unique identifier for the student
    var id: String
    
    // Student's name
    var name: String
    
    // List of all transactions (income or expenses)
    // Published so UI updates automatically when new transactions are added
    @Published var transactions: [Transaction] = []

    // Initializer for a student
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    // Add a transaction (income or expense) to the student's transaction list
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }

    // Calculate total income of the student
    func totalIncome() -> Double {
        transactions
            .filter { $0.type == "Income" }  // Only include income transactions
            .reduce(0) { $0 + $1.amount }    // Sum up all income amounts
    }

    // Calculate total expenses of the student
    func totalExpenses() -> Double {
        transactions
            .filter { $0.type == "Expense" }  // Only include expense transactions
            .reduce(0) { $0 + $1.amount }    // Sum up all expense amounts
    }

    // Calculate balance = income - expenses
    func balance() -> Double {
        totalIncome() - totalExpenses()
    }

    // Get total expenses grouped by category
    func expensesByCategory() -> [String: Double] {
        var result: [String: Double] = [:]
        for t in transactions where t.type == "Expense" {
            result[t.category, default: 0] += t.amount  // Sum expenses for each category
        }
        return result
    }
}
