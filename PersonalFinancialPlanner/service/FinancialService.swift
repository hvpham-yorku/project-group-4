import Foundation

final class FinancialService {
    private let repository: StudentRepository

    init(repository: StudentRepository) {
        self.repository = repository
    }

    func addIncome(student: Student, amount: Double, category: String) {
        let tx = Transaction(
            id: UUID().uuidString,
            amount: amount,
            date: Date(),
            type: "Income",
            category: category
        )
        student.transactions.append(tx)
    }

    func addExpense(student: Student, amount: Double, category: String) {
        let tx = Transaction(
            id: UUID().uuidString,
            amount: amount,
            date: Date(),
            type: "Expense",
            category: category
        )
        student.transactions.append(tx)
    }
}
