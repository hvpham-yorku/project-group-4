//
//  Budget.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//

import Foundation

class Budget {
    var category: String
    var limit: Double

    init(category: String, limit: Double) {
        self.category = category
        self.limit = limit
    }

    func remaining(spent: Double) -> Double {
        limit - spent
    }
}
