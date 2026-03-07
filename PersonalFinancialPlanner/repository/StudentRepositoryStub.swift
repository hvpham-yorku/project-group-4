//
//  StudentRepositoryStub.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.Edited by Mehrshad Zarastounia
//

import Foundation
import Combine

// Stub repository used for testing and development
// Data is stored only in memory
final class StudentRepositoryStub: ObservableObject, StudentRepository {
    
    // Published so SwiftUI refreshes when the array changes
    @Published private var students: [Student] = []
    
    init() {
        seedDefaultData()
    }
    
    // Creates default sample data for the stub repository
    private func seedDefaultData() {
        let alice = Student(id: "S001", name: "Alice")
        let bob = Student(id: "S002", name: "Bob")
        
        students = [alice, bob]
    }
    
    // Returns all students
    func getAllStudents() -> [Student] {
        students
    }
    
    // Returns a specific student by ID
    func findStudent(byId id: String) -> Student? {
        students.first { $0.id == id }
    }
    
    // Updates an existing student or inserts a new one
    func saveStudent(_ student: Student) {
        if let index = students.firstIndex(where: { $0.id == student.id }) {
            students[index] = student
        } else {
            students.append(student)
        }
        
        // Force SwiftUI refresh for repository observers
        objectWillChange.send()
    }
}
