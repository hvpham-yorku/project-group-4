//
//  StudentRepositoryReal.swift
//  PersonalFinancialPlanner
//
//  Created by Mehrshad Zarastounia on 2026-03-05.
//

import Foundation
import Combine

// Real repository with persistent local storage using JSON file
// This acts as the "real database" for Iteration 2
final class StudentRepositoryReal: ObservableObject, StudentRepository {
    
    @Published private var students: [Student] = []
    
    // File name used for persistent storage
    private let fileName = "students_db.json"
    
    init() {
        loadStudents()
        
        // If no data exists yet, create default seed data
        if students.isEmpty {
            seedDefaultData()
            persistStudents()
        }
    }
    
    // Returns all students
    func getAllStudents() -> [Student] {
        students
    }
    
    // Returns a student by ID
    func findStudent(byId id: String) -> Student? {
        students.first { $0.id == id }
    }
    
    // Saves or updates a student, then persists data to disk
    func saveStudent(_ student: Student) {
        if let index = students.firstIndex(where: { $0.id == student.id }) {
            students[index] = student
        } else {
            students.append(student)
        }
        
        persistStudents()
        objectWillChange.send()
    }
    
    // MARK: - Private Helpers
    
    // Seeds the repository with default data
    private func seedDefaultData() {
        let alice = Student(id: "S001", name: "Alice")
        let bob = Student(id: "S002", name: "Bob")
        
        students = [alice, bob]
    }
    
    // Loads students from the local JSON file
    private func loadStudents() {
        let url = databaseURL()
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            students = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            students = try JSONDecoder().decode([Student].self, from: data)
        } catch {
            print("Failed to load student database: \(error.localizedDescription)")
            students = []
        }
    }
    
    // Saves students to the local JSON file
    private func persistStudents() {
        do {
            let data = try JSONEncoder().encode(students)
            try data.write(to: databaseURL(), options: Data.WritingOptions.atomic)
        } catch {
            print("Failed to save student database: \(error.localizedDescription)")
        }
    }
    
    // Returns the file URL for the local database file
    private func databaseURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName)
    }
}
