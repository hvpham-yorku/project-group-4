//
//  FinancialService.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.Edited by Mehrshad Zarastounia
//

import Foundation

// Handles business logic for student finances
final class FinancialService {
    
    private let repository: StudentRepository
    
    init(repository: StudentRepository) {
        self.repository = repository
    }
    
    // Adds an income transaction for a student
    func addIncome(studentId: String, amount: Double, category: String, recurrence: Recurrence = .none) {
        guard let student = repository.findStudent(byId: studentId) else { return }
        
        let transaction = Transaction(
            id: UUID().uuidString,
            amount: amount,
            date: Date(),
            type: "Income",
            category: category
        )
        
        student.addTransaction(transaction)
        repository.saveStudent(student)
        
        handleRecurrence(
            for: student,
            amount: amount,
            category: category,
            type: "Income",
            recurrence: recurrence
        )
    }
    
    // Adds an expense transaction for a student
    func addExpense(studentId: String, amount: Double, category: String, recurrence: Recurrence = .none) {
        guard let student = repository.findStudent(byId: studentId) else { return }
        
        let transaction = Transaction(
            id: UUID().uuidString,
            amount: amount,
            date: Date(),
            type: "Expense",
            category: category
        )
        
        student.addTransaction(transaction)
        repository.saveStudent(student)
        
        handleRecurrence(
            for: student,
            amount: amount,
            category: category,
            type: "Expense",
            recurrence: recurrence
        )
    }
    
    // Creates future recurring transactions
    private func handleRecurrence(
        for student: Student,
        amount: Double,
        category: String,
        type: String,
        recurrence: Recurrence
    ) {
        let calendar = Calendar.current
        var nextDate = Date()
        
        let occurrences: Int
        
        switch recurrence {
        case .none:
            return
        case .weekly:
            occurrences = 12
        case .biweekly:
            occurrences = 12
        case .monthly:
            occurrences = 12
        }
        
        for _ in 1...occurrences {
            switch recurrence {
            case .weekly:
                nextDate = calendar.date(byAdding: .weekOfYear, value: 1, to: nextDate) ?? nextDate
            case .biweekly:
                nextDate = calendar.date(byAdding: .weekOfYear, value: 2, to: nextDate) ?? nextDate
            case .monthly:
                nextDate = calendar.date(byAdding: .month, value: 1, to: nextDate) ?? nextDate
            case .none:
                break
            }
            
            let futureTransaction = Transaction(
                id: UUID().uuidString,
                amount: amount,
                date: nextDate,
                type: type,
                category: category
            )
            
            student.addTransaction(futureTransaction)
        }
        
        repository.saveStudent(student)
    }
}
