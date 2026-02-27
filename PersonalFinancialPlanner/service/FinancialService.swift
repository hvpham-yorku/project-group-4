import Foundation

class FinancialService {
    private let repository: StudentRepository

    init(repository: StudentRepository) {
        self.repository = repository
    }

    func addIncome(studentId: String, amount: Double, category: String) {
        // Attempt to find the student; exit early if not found
        guard let student = repository.findStudent(byId: studentId) else { return }

        // Use a dictionary-style initializer for clarity (same effect)
        let transactionDetails: [String: Any] = [
            "id": UUID().uuidString,
            "amount": amount,
            "date": Date(),
            "type": "Income",
            "category": category
        ]

        // Create the transaction using the dictionary values
        let transaction = Transaction(
            id: transactionDetails["id"] as! String,
            amount: transactionDetails["amount"] as! Double,
            date: transactionDetails["date"] as! Date,
            type: transactionDetails["type"] as! String,
            category: transactionDetails["category"] as! String
        )

        // Append transaction and save student
        student.addTransaction(transaction)
        repository.saveStudent(student)
    }

    func addExpense(studentId: String, amount: Double, category: String) {
        // Try to find the student; exit early if not found
        guard let student = repository.findStudent(byId: studentId) else { return }

        // Capture the current date once
        let currentDate = Date()

        // Build the transaction
        let transaction = Transaction(
            id: UUID().uuidString,
            amount: amount,
            date: currentDate,
            type: "Expense",
            category: category
        )

        // Append the transaction and persist
        student.addTransaction(transaction)
        repository.saveStudent(student)
    }
}
//testing push
//
