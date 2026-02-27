//
//  FinancialService.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//
import Foundation

// Recurrence enum to match ContentView


class FinancialService {
    private let repository: StudentRepository

    init(repository: StudentRepository) {
        self.repository = repository
    }

    // MARK: - Add Income
    func addIncome(studentId: String, amount: Double, category: String, recurrence: Recurrence = .none) {
        guard let student = repository.findStudent(byId: studentId) else { return }

        // Create the main transaction
        let transaction = Transaction(
            id: UUID().uuidString,
            amount: amount,
            date: Date(),
            type: "Income",
            category: category
        )
        student.addTransaction(transaction)
        repository.saveStudent(student)

        // Handle recurring transactions
        handleRecurrence(for: student, amount: amount, category: category, type: "Income", recurrence: recurrence)
    }

    // MARK: - Add Expense
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

        handleRecurrence(for: student, amount: amount, category: category, type: "Expense", recurrence: recurrence)
    }

    // MARK: - Handle Recurrence (future transactions)
    private func handleRecurrence(for student: Student, amount: Double, category: String, type: String, recurrence: Recurrence) {
        let calendar = Calendar.current
        var nextDate = Date()

        // Number of future occurrences to create (for demo, e.g., 12 months max)
        let occurrences: Int
        switch recurrence {
        case .none:
            return // nothing more to do
        case .weekly:
            occurrences = 12
        case .biweekly:
            occurrences = 12
        case .monthly:
            occurrences = 12
        }

        // Add future recurring transactions
        for _ in 1...occurrences {
            switch recurrence {
            case .weekly:
                nextDate = calendar.date(byAdding: .weekOfYear, value: 1, to: nextDate)!
            case .biweekly:
                nextDate = calendar.date(byAdding: .weekOfYear, value: 2, to: nextDate)!
            case .monthly:
                nextDate = calendar.date(byAdding: .month, value: 1, to: nextDate)!
            default:
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
