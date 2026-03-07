import XCTest
@testable import PersonalFinancialPlanner

final class StudentRepositoryStubTests: XCTestCase {
    
    var repository: StudentRepositoryStub!
    
    override func setUp() {
        super.setUp()
        repository = StudentRepositoryStub()
    }
    
    override func tearDown() {
        repository = nil
        super.tearDown()
    }
    
    func testGetAllStudentsReturnsDefaultStudents() {
        let students = repository.getAllStudents()
        
        XCTAssertEqual(students.count, 2)
        XCTAssertEqual(students[0].id, "S001")
        XCTAssertEqual(students[1].id, "S002")
    }
    
    func testFindStudentByIdReturnsCorrectStudent() {
        let student = repository.findStudent(byId: "S001")
        
        XCTAssertNotNil(student)
        XCTAssertEqual(student?.name, "Alice")
    }
    
    func testFindStudentByIdReturnsNilForMissingStudent() {
        let student = repository.findStudent(byId: "S999")
        
        XCTAssertNil(student)
    }
    
    func testSaveStudentDoesNotCrash() {
        let student = Student(id: "S003", name: "Charlie")
        
        repository.saveStudent(student)
        
        XCTAssertEqual(repository.getAllStudents().count, 2)
    }
}

