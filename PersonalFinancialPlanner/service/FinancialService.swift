//
//  FinancialService.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.Edited by Mehrshad Zarastounia

import Foundation

final class FinancialService {
    
    private let repository: StudentRepository
    
    init(repository: StudentRepository) {
        self.repository = repository
    }
    
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
    
    func semesterRunway(for studentId: String) -> SemesterRunwaySummary? {
        guard
            let student = repository.findStudent(byId: studentId),
            let plan = student.semesterPlan
        else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        
        let futureIncome = student.incomeBetween(start: now, end: plan.endDate)
        let futureExpenses = student.expensesBetween(start: now, end: plan.endDate)
        
        let manualIncoming = plan.upcomingPayments
            .filter { $0.isIncoming && $0.dueDate >= now && $0.dueDate <= plan.endDate }
            .reduce(0) { $0 + $1.amount }
        
        let manualOutgoing = plan.upcomingPayments
            .filter { !$0.isIncoming && $0.dueDate >= now && $0.dueDate <= plan.endDate }
            .reduce(0) { $0 + $1.amount }
        
        let remainingBalance =
            student.balance() +
            futureIncome +
            manualIncoming -
            futureExpenses -
            manualOutgoing
        
        let dayCount = max(1, calendar.dateComponents([.day], from: now, to: plan.endDate).day ?? 1)
        let weeksRemaining = max(1, Int(ceil(Double(dayCount) / 7.0)))
        let safeWeeklySpending = remainingBalance / Double(weeksRemaining)
        
        return SemesterRunwaySummary(
            remainingBalance: remainingBalance,
            safeWeeklySpending: safeWeeklySpending,
            weeksRemaining: weeksRemaining,
            endDate: plan.endDate
        )
    }
    
    func upcomingPayments(for studentId: String) -> [UpcomingPayment] {
        guard
            let student = repository.findStudent(byId: studentId),
            let plan = student.semesterPlan
        else { return [] }
        
        return plan.upcomingPayments.sorted { $0.dueDate < $1.dueDate }
    }
    
    func commuterCosts(for studentId: String) -> CommuterCostSummary? {
        guard
            let student = repository.findStudent(byId: studentId),
            let plan = student.semesterPlan
        else { return nil }
        
        let weeklyTransport = plan.weeklyTTC + plan.weeklyGOTransit
        
        guard let runway = semesterRunway(for: studentId), runway.safeWeeklySpending != 0 else {
            return CommuterCostSummary(
                weeklyTTC: plan.weeklyTTC,
                weeklyGOTransit: plan.weeklyGOTransit,
                transportationBudgetShare: 0
            )
        }
        
        let share = max(0, min(100, (weeklyTransport / max(1, runway.safeWeeklySpending)) * 100))
        
        return CommuterCostSummary(
            weeklyTTC: plan.weeklyTTC,
            weeklyGOTransit: plan.weeklyGOTransit,
            transportationBudgetShare: share
        )
    }
    
    func residenceMealPlanSummary(for studentId: String) -> ResidenceMealPlanSummary? {
        guard
            let student = repository.findStudent(byId: studentId),
            let plan = student.semesterPlan
        else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        let daysRemaining = max(1, calendar.dateComponents([.day], from: now, to: plan.endDate).day ?? 1)
        let weeksRemaining = max(1, Int(ceil(Double(daysRemaining) / 7.0)))
        
        let safeWeeklyFood = plan.mealPlanBalance / Double(weeksRemaining)
        
        return ResidenceMealPlanSummary(
            residencePaid: plan.commuteType == .residence ? plan.monthlyRent : 0,
            remainingMealPlan: plan.mealPlanBalance,
            safeWeeklyFoodSpending: safeWeeklyFood
        )
    }
    
    func nextPaycheckSummary(for studentId: String) -> String? {
        guard
            let student = repository.findStudent(byId: studentId),
            let plan = student.semesterPlan,
            let runway = semesterRunway(for: studentId)
        else { return nil }
        
        let adjustedWeekly = (runway.remainingBalance + plan.nextPaycheckAmount) / Double(max(1, runway.weeksRemaining))
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return "Next paycheck: $\(Int(plan.nextPaycheckAmount)) on \(formatter.string(from: plan.nextPaycheckDate)). Adjusted weekly spending after pay: $\(Int(adjustedWeekly))/week."
    }
    
    func whatIfExpenseImpact(for studentId: String, extraExpense: Double) -> WhatIfResult? {
        guard let runway = semesterRunway(for: studentId) else { return nil }
        
        let newRemaining = runway.remainingBalance - extraExpense
        let newSafeWeekly = newRemaining / Double(max(1, runway.weeksRemaining))
        let lostWeeks = extraExpense / max(1, runway.safeWeeklySpending)
        let runwayDaysReduced = Int(round(lostWeeks * 7))
        
        return WhatIfResult(
            newSafeWeeklySpending: newSafeWeekly,
            runwayDaysReduced: max(0, runwayDaysReduced)
        )
    }
    
    func spendingTrend(for studentId: String) -> SpendingTrendSummary? {
        guard let student = repository.findStudent(byId: studentId) else { return nil }
        
        let monthlyIncome = student.totalIncomeThisMonth()
        let monthlyExpenses = student.totalExpensesThisMonth()
        
        let fixedCategories = ["Rent", "Tuition", "Residence", "Meal Plan", "Phone", "Internet", "Insurance"]
        let categoryTotals = student.expensesByCategory()
        
        let fixedTotal = categoryTotals
            .filter { fixedCategories.contains($0.key) }
            .reduce(0) { $0 + $1.value }
        
        let variableTotal = max(0, monthlyExpenses - fixedTotal)
        let denominator = max(1, monthlyExpenses)
        
        let topCategory = categoryTotals.max(by: { $0.value < $1.value })?.key ?? "None"
        let topAmount = categoryTotals.max(by: { $0.value < $1.value })?.value ?? 0
        
        return SpendingTrendSummary(
            monthIncome: monthlyIncome,
            monthExpenses: monthlyExpenses,
            fixedExpensePercentage: (fixedTotal / denominator) * 100,
            variableExpensePercentage: (variableTotal / denominator) * 100,
            topCategory: topCategory,
            topCategoryAmount: topAmount
        )
    }
    
    func safetyWarnings(for studentId: String) -> [FinancialAlert] {
        guard
            let student = repository.findStudent(byId: studentId),
            let plan = student.semesterPlan
        else { return [] }
        
        var alerts: [FinancialAlert] = []
        
        if let runway = semesterRunway(for: studentId) {
            if runway.safeWeeklySpending < 0 {
                alerts.append(
                    FinancialAlert(
                        title: "Critical runway",
                        message: "At the current plan, expenses exceed available funds before the semester ends.",
                        severity: .critical
                    )
                )
            } else if runway.safeWeeklySpending < 60 {
                alerts.append(
                    FinancialAlert(
                        title: "Low weekly runway",
                        message: "Warning: At current spending rate, your discretionary budget is very tight.",
                        severity: .warning
                    )
                )
            }
        }
        
        let next30Days = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        let upcomingOutgoing = plan.upcomingPayments
            .filter { !$0.isIncoming && $0.dueDate <= next30Days }
            .reduce(0) { $0 + $1.amount }
        
        if student.balance() < upcomingOutgoing {
            alerts.append(
                FinancialAlert(
                    title: "Upcoming bills exceed balance",
                    message: "Alert: Tuition + rent + food in the next month exceed current balance.",
                    severity: .critical
                )
            )
        }
        
        if alerts.isEmpty {
            alerts.append(
                FinancialAlert(
                    title: "Stable outlook",
                    message: "No urgent financial warning detected right now.",
                    severity: .info
                )
            )
        }
        
        return alerts
    }
    
    func yorkSpecificTips() -> [YorkTip] {
        [
            YorkTip(message: "Use York bookstore resale options or used textbook groups to reduce textbook costs."),
            YorkTip(message: "Compare TTC student fares and GO student savings if you commute multiple days each week."),
            YorkTip(message: "Review OSAP release timing before major tuition deadlines so your runway stays realistic.")
        ]
    }
    
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
