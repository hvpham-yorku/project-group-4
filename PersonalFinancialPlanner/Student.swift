//
//  Student.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//

import Foundation

class Student {
    var id: String
    var name: String
    var accounts: [Account] = []

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    func addAccount(_ account: Account) {
        accounts.append(account)
    }

    func totalBalance() -> Double {
        return accounts.reduce(0) { $0 + $1.balance }
    }
}
