import Foundation
import Combine

class Student: ObservableObject {
    var id: String
    var name: String
    @Published var transactions: [Transaction] = []

    init(id: String, name: String) {
        self.id = id
        self.name = name
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
        for t in transactions where t.type == "Expense" {
            result[t.category, default: 0] += t.amount
        }
        return result
    }
}
