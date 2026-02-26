import XCTest
@testable import PersonalFinancialPlanner  // Replace with your app's module name

final class StudentTests: XCTestCase {

    func testAddTransaction() {
        let student = Student(id: "S001", name: "Alice")
        let transaction = Transaction(id: "T001", amount: 100, date: Date(), type: "Income", category: "Allowance")

        student.addTransaction(transaction)

        XCTAssertEqual(student.transactions.count, 1)
        XCTAssertEqual(student.transactions.first?.amount, 100)
        XCTAssertEqual(student.transactions.first?.type, "Income")
    }

    func testTotalIncomeAndExpenses() {
        let student = Student(id: "S001", name: "Alice")

        student.addTransaction(Transaction(id: "T1", amount: 500, date: Date(), type: "Income", category: "Salary"))
        student.addTransaction(Transaction(id: "T2", amount: 200, date: Date(), type: "Expense", category: "Food"))
        student.addTransaction(Transaction(id: "T3", amount: 100, date: Date(), type: "Expense", category: "Transport"))

        XCTAssertEqual(student.totalIncome(), 500)
        XCTAssertEqual(student.totalExpenses(), 300)
        XCTAssertEqual(student.balance(), 200)
    }

    func testExpensesByCategory() {
        let student = Student(id: "S001", name: "Alice")

        student.addTransaction(Transaction(id: "T1", amount: 50, date: Date(), type: "Expense", category: "Food"))
        student.addTransaction(Transaction(id: "T2", amount: 30, date: Date(), type: "Expense", category: "Transport"))
        student.addTransaction(Transaction(id: "T3", amount: 20, date: Date(), type: "Expense", category: "Food"))

        let expenses = student.expensesByCategory()

        XCTAssertEqual(expenses["Food"], 70)
        XCTAssertEqual(expenses["Transport"], 30)
    }
}
