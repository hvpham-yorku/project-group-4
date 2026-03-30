//
//  StudentRepository.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26. Edited by Mehrshad Zarastounia
//


import Foundation

// Protocol that defines required repository operations
protocol StudentRepository: AnyObject {
    
    // Returns all students from the repository
    func getAllStudents() -> [Student]
    
    // Finds and returns a student by ID
    func findStudent(byId id: String) -> Student?
    
    // Finds and returns a student by email
    func findStudent(byEmail email: String) -> Student?
    
    // Login function: returns a student if email/password match
    func login(email: String, password: String) -> Student?
    
    // Saves or updates a student in the repository
    func saveStudent(_ student: Student)
    
    // Deletes a student (optional: test accounts cannot be deleted)
    func deleteStudent(_ student: Student)
}
