//
//  Student.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.Edited By Mehrshad Zarastounia
//


import Foundation
import Combine

final class Student: ObservableObject, Codable {
    
    var id: String
    var name: String
    
    @Published var transactions: [Transaction]
    var semesterPlan: SemesterPlan?
    
    init(
        id: String,
        name: String,
        transactions: [Transaction] = [],
        semesterPlan: SemesterPlan? = nil
    ) {
        self.id = id
        self.name = name
        self.transactions = transactions
        self.semesterPlan = semesterPlan
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }
    
    func totalIncome() -> Double {
        transactions
            .filter { $0.type == "Income" }
            .reduce(0) { $0 + $1.amount }
    }
    
    func totalExpenses() -> Double {
        transactions
            .filter { $0.type == "Expense" }
            .reduce(0) { $0 + $1.amount }
    }
    
    func balance() -> Double {
        totalIncome() - totalExpenses()
    }
    
    func expensesByCategory() -> [String: Double] {
        var result: [String: Double] = [:]
        
        for transaction in transactions where transaction.type == "Expense" {
            result[transaction.category, default: 0] += transaction.amount
        }
        
        return result
    }
    
    func incomeBetween(start: Date, end: Date) -> Double {
        transactions
            .filter {
                $0.type == "Income" &&
                $0.date >= start &&
                $0.date <= end
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    func expensesBetween(start: Date, end: Date) -> Double {
        transactions
            .filter {
                $0.type == "Expense" &&
                $0.date >= start &&
                $0.date <= end
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case transactions
        case semesterPlan
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        transactions = try container.decode([Transaction].self, forKey: .transactions)
        semesterPlan = try container.decodeIfPresent(SemesterPlan.self, forKey: .semesterPlan)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(transactions, forKey: .transactions)
        try container.encodeIfPresent(semesterPlan, forKey: .semesterPlan)
    }
}
