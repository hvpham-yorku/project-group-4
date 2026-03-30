import Foundation

struct Transaction: Identifiable, Codable {
    var id: String
    var amount: Double
    var date: Date
    var type: String  // "Income" or "Expense"
    var category: String
}

