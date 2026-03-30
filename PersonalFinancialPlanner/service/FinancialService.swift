import Foundation

enum TransactionType: String, Codable {
    case income = "Income"
    case expense = "Expense"
}

final class FinancialService {
    private let repository: StudentRepository

    init(repository: StudentRepository) {
        self.repository = repository
    }

    private func createTransaction(for student: Student, amount: Double, type: TransactionType, category: String) {
        let tx = Transaction(
            id: UUID().uuidString,
            amount: amount,
            date: Date(),
            type: type.rawValue, 
            category: category
        )
        student.transactions.append(tx)
    }

    func addIncome(student: Student, amount: Double, category: String) {
        createTransaction(for: student, amount: amount, type: .income, category: category)
    }

    func addExpense(student: Student, amount: Double, category: String) {
        createTransaction(for: student, amount: amount, type: .expense, category: category)
    }

    private func sumTransactions(for student: Student, ofType type: TransactionType) -> Double {
        return student.transactions
            .filter { $0.type == type.rawValue }
            .reduce(0) { $0 + $1.amount }
    }

    func totalIncome(student: Student) -> Double {
        return sumTransactions(for: student, ofType: .income)
    }

    func totalExpenses(student: Student) -> Double {
        return sumTransactions(for: student, ofType: .expense)
    }

    func expensesByCategory(student: Student) -> [String: Double] {
        var result: [String: Double] = [:]
        
        for transaction in student.transactions where transaction.type == TransactionType.expense.rawValue {
            let normalizedCategory = transaction.category.lowercased()
            result[normalizedCategory, default: 0] += transaction.amount
        }
        
        return result
    }
}
