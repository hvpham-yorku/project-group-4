import Foundation
import Combine

final class StudentRepositoryStub: ObservableObject, StudentRepository {

    @Published var students: [Student] = []

    init() { seedDefaultData() }

    private func seedDefaultData() {
        // No sample transactions — clean slate for each account
        let alice = Student(
            id: "S001", name: "Alice",
            email: "alice@yorku.ca", password: "Alice123",
            transactions: [], semesterPlan: nil
        )
        let bob = Student(
            id: "S002", name: "Bob",
            email: "bob@yorku.ca", password: "Bob123",
            transactions: [], semesterPlan: nil
        )
        let tester = Student(
            id: "T001", name: "Tester",
            email: "tester@yorku.ca", password: "Test1234",
            transactions: [], semesterPlan: nil
        )
        students = [alice, bob, tester]
    }

    // MARK: - Protocol

    func getAllStudents() -> [Student] { students }

    func findStudent(byId id: String) -> Student? {
        students.first { $0.id == id }
    }

    func findStudent(byEmail email: String) -> Student? {
        students.first { $0.email.lowercased() == email.lowercased() }
    }

    func login(email: String, password: String) -> Student? {
        students.first { $0.email.lowercased() == email.lowercased() && $0.password == password }
    }

    func saveStudent(_ student: Student) {
        // Student is a class — mutations already reflected in array.
        // Only append if brand-new.
        if !students.contains(where: { $0.id == student.id }) {
            students.append(student)
        }
        objectWillChange.send()
    }

    func deleteStudent(_ student: Student) {
        students.removeAll { $0.id == student.id }
        objectWillChange.send()
    }
}
