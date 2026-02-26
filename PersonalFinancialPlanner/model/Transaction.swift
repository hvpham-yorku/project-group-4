import Foundation

class Transaction {
    var id: String
    var amount: Double
    var date: Date
    var type: String   // "Income" or "Expense"
    var category: String

    init(id: String, amount: Double, date: Date, type: String, category: String) {
        self.id = id
        self.amount = amount
        self.date = date
        self.type = type
        self.category = category
    }
}
