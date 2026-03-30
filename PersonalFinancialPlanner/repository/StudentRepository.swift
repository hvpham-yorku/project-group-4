import Foundation

protocol StudentRepository: AnyObject {
    func getAllStudents() -> [Student]
    func findStudent(byId id: String) -> Student?
    func findStudent(byEmail email: String) -> Student?
    func login(email: String, password: String) -> Student?
    func saveStudent(_ student: Student)
    func deleteStudent(_ student: Student)
}
