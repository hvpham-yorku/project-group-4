import Foundation
import Combine

final class StudentRepositoryStub: ObservableObject, StudentRepository {
    
    @Published var students: [Student] = []
    
    init() {
        seedDefaultData()
    }
    
    private func seedDefaultData() {
        let calendar = Calendar.current
        let now = Date()
        
        let alice = Student(
            id: "S001",
            name: "Alice",
            email: "alice@yorku.ca",
            password: "Alice123",
            transactions: [
                Transaction(id: UUID().uuidString, amount: 3200, date: calendar.date(byAdding: .day, value: -12, to: now) ?? now, type: "Income", category: "OSAP"),
                Transaction(id: UUID().uuidString, amount: 900, date: calendar.date(byAdding: .day, value: -9, to: now) ?? now, type: "Income", category: "Part-Time Job"),
                Transaction(id: UUID().uuidString, amount: 1500, date: calendar.date(byAdding: .day, value: -8, to: now) ?? now, type: "Expense", category: "Rent"),
                Transaction(id: UUID().uuidString, amount: 180, date: calendar.date(byAdding: .day, value: -6, to: now) ?? now, type: "Expense", category: "Groceries"),
                Transaction(id: UUID().uuidString, amount: 65, date: calendar.date(byAdding: .day, value: -5, to: now) ?? now, type: "Expense", category: "TTC"),
                Transaction(id: UUID().uuidString, amount: 120, date: calendar.date(byAdding: .day, value: -2, to: now) ?? now, type: "Expense", category: "Food")
            ]
        )
        
        let bob = Student(
            id: "S002",
            name: "Bob",
            email: "bob@yorku.ca",
            password: "Bob123",
            transactions: []
        )
        
        let tester = Student(
            id: "T001",
            name: "Tester",
            email: "tester@yorku.ca",
            password: "Test1234",
            transactions: []
        )
        
        students = [alice, bob, tester]
    }
    
    // MARK: - Protocol methods
    func getAllStudents() -> [Student] { students }
    
    func findStudent(byId id: String) -> Student? { students.first { $0.id == id } }
    
    func findStudent(byEmail email: String) -> Student? { students.first { $0.email.lowercased() == email.lowercased() } }
    
    func login(email: String, password: String) -> Student? {
        students.first { $0.email.lowercased() == email.lowercased() && $0.password == password }
    }
    
    func saveStudent(_ student: Student) {
        if let index = students.firstIndex(where: { $0.id == student.id }) {
            students[index] = student
        } else {
            students.append(student)
        }
        objectWillChange.send()
    }
    
    func deleteStudent(_ student: Student) {
        students.removeAll { $0.id == student.id }
        objectWillChange.send()
    }
}
