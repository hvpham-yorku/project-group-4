import Foundation
import Combine

final class Student: Identifiable, ObservableObject, Codable {
    let id: String
    let name: String
    let email: String
    let password: String

    @Published var transactions: [Transaction]
    @Published var semesterPlan: SemesterPlan?

    init(id: String, name: String, email: String, password: String,
         transactions: [Transaction] = [], semesterPlan: SemesterPlan? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.transactions = transactions
        self.semesterPlan = semesterPlan
    }

    func balance() -> Double {
        transactions.reduce(0) { $0 + ($1.type == "Income" ? $1.amount : -$1.amount) }
    }

    func totalIncome() -> Double {
        transactions.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }
    }

    func totalExpenses() -> Double {
        transactions.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
    }

    func totalIncomeThisMonth() -> Double {
        let cal = Calendar.current; let now = Date()
        return transactions
            .filter { $0.type == "Income" && cal.isDate($0.date, equalTo: now, toGranularity: .month) }
            .reduce(0) { $0 + $1.amount }
    }

    func totalExpensesThisMonth() -> Double {
        let cal = Calendar.current; let now = Date()
        return transactions
            .filter { $0.type == "Expense" && cal.isDate($0.date, equalTo: now, toGranularity: .month) }
            .reduce(0) { $0 + $1.amount }
    }

    func expensesByCategory() -> [String: Double] {
        var result: [String: Double] = [:]
        for t in transactions where t.type == "Expense" {
            result[t.category, default: 0] += t.amount
        }
        return result
    }

    func incomeBetween(start: Date, end: Date) -> Double {
        transactions.filter { $0.type == "Income" && $0.date >= start && $0.date <= end }
            .reduce(0) { $0 + $1.amount }
    }

    func expensesBetween(start: Date, end: Date) -> Double {
        transactions.filter { $0.type == "Expense" && $0.date >= start && $0.date <= end }
            .reduce(0) { $0 + $1.amount }
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, name, email, password, transactions, semesterPlan
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id           = try c.decode(String.self, forKey: .id)
        name         = try c.decode(String.self, forKey: .name)
        email        = try c.decode(String.self, forKey: .email)
        password     = try c.decode(String.self, forKey: .password)
        transactions = try c.decode([Transaction].self, forKey: .transactions)
        semesterPlan = try c.decodeIfPresent(SemesterPlan.self, forKey: .semesterPlan)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id,           forKey: .id)
        try c.encode(name,         forKey: .name)
        try c.encode(email,        forKey: .email)
        try c.encode(password,     forKey: .password)
        try c.encode(transactions, forKey: .transactions)
        try c.encodeIfPresent(semesterPlan, forKey: .semesterPlan)
    }
}
