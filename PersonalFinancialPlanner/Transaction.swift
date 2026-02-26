//
//  Transaction.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//

import Foundation

class Transaction {
    var id: String
    var amount: Double
    var date: Date
    var type: String   // "Income" or "Expense"

    init(id: String, amount: Double, date: Date, type: String) {
        self.id = id
        self.amount = amount
        self.date = date
        self.type = type
    }
}
