//
//  Budget.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//

import Foundation

class Budget {
    var studentId: String
    var category: String
    var limit: Double
    var spent: Double = 0

    init(studentId: String, category: String, limit: Double) {
        self.studentId = studentId
        self.category = category
        self.limit = limit
    }

    func addExpense(_ amount: Double) {
        spent += amount
    }

    func remaining() -> Double {
        return limit - spent
    }
}
