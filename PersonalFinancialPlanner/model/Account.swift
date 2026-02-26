//
//  Account.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//

import Foundation

class Account {
    var id: String
    var type: String
    var balance: Double

    init(id: String, type: String, balance: Double) {
        self.id = id
        self.type = type
        self.balance = balance
    }
}
