
import Foundation

class StudentRepositoryStub: StudentRepository {
    private var students: [Student] = []

    init() {
        let alice = Student(id: "S001", name: "Alice")
        students.append(alice)

        let bob = Student(id: "S002", name: "Bob")
        students.append(bob)
    }

    func getAllStudents() -> [Student] {
        students
    }

    func findStudent(byId id: String) -> Student? {
        students.first { $0.id == id }
    }

    func saveStudent(_ student: Student) {
        // stub: no actual DB persistence
    }
}
