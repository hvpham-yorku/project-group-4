//
//  StudentRepositoryStub.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//
import Foundation
import Combine

// Stub repository for testing and development
// Conforms to ObservableObject so SwiftUI views can observe changes
// Also conforms to StudentRepository protocol
class StudentRepositoryStub: ObservableObject, StudentRepository {
    
    // Published array of students, so UI updates automatically when it changes
    @Published var students: [Student] = []

    // Initializer creates some sample students
    init() {
        // Sample student 1
        let alice = Student(id: "S001", name: "Alice")
        students.append(alice)

        // Sample student 2
        let bob = Student(id: "S002", name: "Bob")
        students.append(bob)
    }

    // Return all students in the repository
    func getAllStudents() -> [Student] {
        students
    }

    // Find a student by their ID
    func findStudent(byId id: String) -> Student? {
        students.first { $0.id == id }
    }

    // Save a student to the repository
    // Stub: no real database, so this does nothing
    func saveStudent(_ student: Student) {
        // Intentionally left blank for stub
    }
}
