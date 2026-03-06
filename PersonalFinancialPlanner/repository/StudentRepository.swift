//
//  StudentRepository.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26. Edited by Mehrshad Zarastounia
//

import Foundation

// Protocol that defines the required repository operations
protocol StudentRepository: AnyObject {
    
    // Returns all students from the repository
    func getAllStudents() -> [Student]
    
    // Finds and returns a student by ID
    func findStudent(byId id: String) -> Student?
    
    // Saves or updates a student in the repository
    func saveStudent(_ student: Student)
}
