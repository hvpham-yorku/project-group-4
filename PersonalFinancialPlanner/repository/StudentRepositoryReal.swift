import Foundation
import Combine

final class StudentRepositoryReal: ObservableObject, StudentRepository {

    @Published private(set) var students: [Student] = []

    init() {
        students = [
            Student(
                id: "S001", name: "Alice",
                email: "alice@yorku.ca", password: "Alice123",
                transactions: [
                    Transaction(id: UUID().uuidString, amount: 3000, date: Date(), type: "Income",  category: "OSAP"),
                    Transaction(id: UUID().uuidString, amount: 1200, date: Date(), type: "Expense", category: "Rent")
                ]
            ),
            Student(
                id: "S002", name: "Bob",
                email: "bob@yorku.ca", password: "Bob123",
                transactions: [
                    Transaction(id: UUID().uuidString, amount: 2500, date: Date(), type: "Income",  category: "Part-time"),
                    Transaction(id: UUID().uuidString, amount: 1000, date: Date(), type: "Expense", category: "Rent")
                ]
            )
        ]
    }

    // MARK: - Protocol

    func getAllStudents() -> [Student] { students }

    func findStudent(byId id: String) -> Student? { students.first { $0.id == id } }

    func findStudent(byEmail email: String) -> Student? {
        students.first { $0.email.lowercased() == email.lowercased() }
    }

    func login(email: String, password: String) -> Student? {
        students.first { $0.email.lowercased() == email.lowercased() && $0.password == password }
    }

    func saveStudent(_ student: Student) {
        // Student is a class — mutations already reflected. Only append new ones.
        if !students.contains(where: { $0.id == student.id }) {
            students.append(student)
        }
        objectWillChange.send()
    }

    func deleteStudent(_ student: Student) {
        if student.id == "S001" || student.id == "S002" { return }
        students.removeAll { $0.id == student.id }
        objectWillChange.send()
    }
}
