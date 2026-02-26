import XCTest
@testable import PersonalFinancialPlanner  // Replace with your app's module name

final class FinancialServiceTests: XCTestCase {
    var repository: StudentRepositoryStub!
    var service: FinancialService!

    override func setUp() {
        super.setUp()
        repository = StudentRepositoryStub()
        service = FinancialService(repository: repository)
    }

    override func tearDown() {
        repository = nil
        service = nil
        super.tearDown()
    }

    func testAddIncome() {
        // Given
        let studentId = "S001"
        let amount = 500.0
        let category = "Allowance"

        // When
        service.addIncome(studentId: studentId, amount: amount, category: category)

        // Then
        guard let student = repository.findStudent(byId: studentId) else {
            XCTFail("Student not found")
            return
        }

        let incomeTransactions = student.transactions.filter { $0.type == "Income" }
        XCTAssertEqual(incomeTransactions.count, 1)
        XCTAssertEqual(incomeTransactions.first?.amount, amount)
        XCTAssertEqual(incomeTransactions.first?.category, category)
    }

    func testAddExpense() {
        // Given
        let studentId = "S001"
        let amount = 200.0
        let category = "Food"

        // When
        service.addExpense(studentId: studentId, amount: amount, category: category)

        // Then
        guard let student = repository.findStudent(byId: studentId) else {
            XCTFail("Student not found")
            return
        }

        let expenseTransactions = student.transactions.filter { $0.type == "Expense" }
        XCTAssertEqual(expenseTransactions.count, 1)
        XCTAssertEqual(expenseTransactions.first?.amount, amount)
        XCTAssertEqual(expenseTransactions.first?.category, category)
    }

    func testAddMultipleTransactions() {
        let studentId = "S001"

        service.addIncome(studentId: studentId, amount: 1000, category: "Salary")
        service.addExpense(studentId: studentId, amount: 300, category: "Rent")
        service.addExpense(studentId: studentId, amount: 50, category: "Food")

        guard let student = repository.findStudent(byId: studentId) else {
            XCTFail("Student not found")
            return
        }

        XCTAssertEqual(student.transactions.count, 3)
        XCTAssertEqual(student.totalIncome(), 1000)
        XCTAssertEqual(student.totalExpenses(), 350)
        XCTAssertEqual(student.balance(), 650)
    }
}
