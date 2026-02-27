//
//  StudentRepository.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//
import Foundation

// Protocol for the student repository
// Defines the methods any repository class must implement
protocol StudentRepository {
    
    // Returns a list of all students
    func getAllStudents() -> [Student]
    
    // Finds a student by their unique ID
    // Returns the student if found, otherwise nil
    func findStudent(byId id: String) -> Student?
    
    // Saves a student to the repository
    // For a real database, this would persist the data
    func saveStudent(_ student: Student)
}
