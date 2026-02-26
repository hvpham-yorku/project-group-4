//
//  StudentRepository.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//
import Foundation

protocol StudentRepository {
    func getAllStudents() -> [Student]
    func findStudent(byId id: String) -> Student?
    func saveStudent(_ student: Student)
}
