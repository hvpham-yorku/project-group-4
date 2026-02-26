import Foundation

class FinancialService {
    private let repository: StudentRepository

    init(repository: StudentRepository) {
        self.repository = repository
    }

    func addIncome(studentId: String, amount: Double, category: String) {
        guard let student = repository.findStudent(byId: studentId) else { return }

        let transaction = Transaction(
            id: UUID().uuidString,
            amount: amount,
            date: Date(),
            type: "Income",
            category: category
        )

        student.addTransaction(transaction)
        repository.saveStudent(student)
    }

    func addExpense(studentId: String, amount: Double, category: String) {
        guard let student = repository.findStudent(byId: studentId) else { return }

        let transaction = Transaction(
            id: UUID().uuidString,
            amount: amount,
            date: Date(),
            type: "Expense",
            category: category
        )

        student.addTransaction(transaction)
        repository.saveStudent(student)
    }
}
