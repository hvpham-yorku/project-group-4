import Foundation
import Combine

final class StudentRepositoryReal: ObservableObject, StudentRepository {
    @Published private(set) var students: [Student] = []
    
    init() {
        // Preloaded test students
        students = [
            Student(
                id: "S001",
                name: "Alice",
                email: "alice@yorku.ca",
                password: "Alice123",
                transactions: [
                    Transaction(id: UUID().uuidString, amount: 3000, date: Date(), type: "Income", category: "OSAP"),
                    Transaction(id: UUID().uuidString, amount: 1200, date: Date(), type: "Expense", category: "Rent")
                ]
            ),
            Student(
                id: "S002",
                name: "Bob",
                email: "bob@yorku.ca",
                password: "Bob123",
                transactions: [
                    Transaction(id: UUID().uuidString, amount: 2500, date: Date(), type: "Income", category: "Part-time"),
                    Transaction(id: UUID().uuidString, amount: 1000, date: Date(), type: "Expense", category: "Rent")
                ]
            )
        ]
    }
    
    // MARK: - Protocol methods
    
    func getAllStudents() -> [Student] {
        return students
    }
    
    func findStudent(byId id: String) -> Student? {
        return students.first(where: { $0.id == id })
    }
    
    func findStudent(byEmail email: String) -> Student? {
        return students.first(where: { $0.email.lowercased() == email.lowercased() })
    }
    
    func login(email: String, password: String) -> Student? {
        return students.first { $0.email.lowercased() == email.lowercased() && $0.password == password }
    }
    
    func saveStudent(_ student: Student) {
        if let index = students.firstIndex(where: { $0.id == student.id }) {
            students[index] = student
        } else {
            students.append(student)
        }
    }
    
    func deleteStudent(_ student: Student) {
        // Prevent deleting test accounts
        if student.id == "S001" || student.id == "S002" { return }
        students.removeAll(where: { $0.id == student.id })
    }
}
