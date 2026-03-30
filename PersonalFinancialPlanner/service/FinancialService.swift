import Foundation

final class FinancialService {

    private let repository: StudentRepository

    init(repository: StudentRepository) {
        self.repository = repository
    }

    // MARK: - Add Transactions

    func addIncome(studentId: String, amount: Double, category: String,
                   date: Date = Date(), recurrence: Recurrence = .none) {
        guard let student = repository.findStudent(byId: studentId) else { return }
        let tx = Transaction(id: UUID().uuidString, amount: amount, date: date, type: "Income", category: category)
        student.transactions.append(tx)
        repository.saveStudent(student)
        handleRecurrence(for: student, amount: amount, category: category, type: "Income", startDate: date, recurrence: recurrence)
    }

    func addExpense(studentId: String, amount: Double, category: String,
                    date: Date = Date(), recurrence: Recurrence = .none) {
        guard let student = repository.findStudent(byId: studentId) else { return }
        let tx = Transaction(id: UUID().uuidString, amount: amount, date: date, type: "Expense", category: category)
        student.transactions.append(tx)
        repository.saveStudent(student)
        handleRecurrence(for: student, amount: amount, category: category, type: "Expense", startDate: date, recurrence: recurrence)
    }

    // Legacy signatures used by old ProfileView/LoginView callers
    func addIncome(student: Student, amount: Double, category: String) {
        addIncome(studentId: student.id, amount: amount, category: category)
    }

    func addExpense(student: Student, amount: Double, category: String) {
        addExpense(studentId: student.id, amount: amount, category: category)
    }

    // MARK: - Semester Runway

    func semesterRunway(for studentId: String) -> SemesterRunwaySummary? {
        guard let student = repository.findStudent(byId: studentId),
              let plan = student.semesterPlan else { return nil }

        let cal = Calendar.current
        let now = Date()

        let manualIncoming = plan.upcomingPayments
            .filter { $0.isIncoming && $0.dueDate >= now && $0.dueDate <= plan.endDate }
            .reduce(0) { $0 + $1.amount }
        let manualOutgoing = plan.upcomingPayments
            .filter { !$0.isIncoming && $0.dueDate >= now && $0.dueDate <= plan.endDate }
            .reduce(0) { $0 + $1.amount }

        let remainingBalance = student.balance() + manualIncoming - manualOutgoing

        let dayCount = max(1, cal.dateComponents([.day], from: now, to: plan.endDate).day ?? 1)
        let weeksRemaining = max(1, Int(ceil(Double(dayCount) / 7.0)))
        let safeWeeklySpending = remainingBalance / Double(weeksRemaining)

        return SemesterRunwaySummary(
            remainingBalance: remainingBalance,
            safeWeeklySpending: safeWeeklySpending,
            weeksRemaining: weeksRemaining,
            endDate: plan.endDate
        )
    }

    // MARK: - Upcoming Payments

    func upcomingPayments(for studentId: String) -> [UpcomingPayment] {
        guard let student = repository.findStudent(byId: studentId),
              let plan = student.semesterPlan else { return [] }
        return plan.upcomingPayments.sorted { $0.dueDate < $1.dueDate }
    }

    // MARK: - Commuter Costs

    func commuterCosts(for studentId: String) -> CommuterCostSummary? {
        guard let student = repository.findStudent(byId: studentId),
              let plan = student.semesterPlan else { return nil }
        let weeklyTransport = plan.weeklyTTC + plan.weeklyGOTransit
        guard let runway = semesterRunway(for: studentId), runway.safeWeeklySpending != 0 else {
            return CommuterCostSummary(weeklyTTC: plan.weeklyTTC, weeklyGOTransit: plan.weeklyGOTransit, transportationBudgetShare: 0)
        }
        let share = max(0, min(100, (weeklyTransport / max(1, runway.safeWeeklySpending)) * 100))
        return CommuterCostSummary(weeklyTTC: plan.weeklyTTC, weeklyGOTransit: plan.weeklyGOTransit, transportationBudgetShare: share)
    }

    // MARK: - Residence / Meal Plan

    func residenceMealPlanSummary(for studentId: String) -> ResidenceMealPlanSummary? {
        guard let student = repository.findStudent(byId: studentId),
              let plan = student.semesterPlan else { return nil }
        let cal = Calendar.current; let now = Date()
        let daysRemaining = max(1, cal.dateComponents([.day], from: now, to: plan.endDate).day ?? 1)
        let weeksRemaining = max(1, Int(ceil(Double(daysRemaining) / 7.0)))
        return ResidenceMealPlanSummary(
            residencePaid: plan.commuteType == .residence ? plan.monthlyRent : 0,
            remainingMealPlan: plan.mealPlanBalance,
            safeWeeklyFoodSpending: plan.mealPlanBalance / Double(weeksRemaining)
        )
    }

    // MARK: - Next Paycheck

    func nextPaycheckSummary(for studentId: String) -> String? {
        guard let student = repository.findStudent(byId: studentId),
              let plan = student.semesterPlan,
              let runway = semesterRunway(for: studentId) else { return nil }
        let adjusted = (runway.remainingBalance + plan.nextPaycheckAmount) / Double(max(1, runway.weeksRemaining))
        let f = DateFormatter(); f.dateStyle = .medium
        return "Next paycheck: $\(Int(plan.nextPaycheckAmount)) on \(f.string(from: plan.nextPaycheckDate)). Adjusted weekly spending after pay: $\(Int(adjusted))/week."
    }

    // MARK: - What-If

    func whatIfExpenseImpact(for studentId: String, extraExpense: Double) -> WhatIfResult? {
        guard let runway = semesterRunway(for: studentId) else { return nil }

        let newRemaining = runway.remainingBalance - extraExpense
        let newSafeWeekly = newRemaining / Double(max(1, runway.weeksRemaining))

        let runwayDaysReduced: Int
        if runway.safeWeeklySpending > 0 {
            let oldDays = (runway.remainingBalance / runway.safeWeeklySpending) * 7
            let newDays = max(0, newRemaining / runway.safeWeeklySpending) * 7
            runwayDaysReduced = max(0, Int(round(oldDays - newDays)))
        } else {
            let dailyCost = extraExpense / Double(max(1, runway.weeksRemaining)) / 7
            runwayDaysReduced = dailyCost > 0 ? Int(round(extraExpense / dailyCost)) : 0
        }

        return WhatIfResult(newSafeWeeklySpending: newSafeWeekly, runwayDaysReduced: runwayDaysReduced)
    }

    // MARK: - Spending Trend

    func spendingTrend(for studentId: String) -> SpendingTrendSummary? {
        guard let student = repository.findStudent(byId: studentId) else { return nil }
        let monthlyIncome = student.totalIncomeThisMonth()
        let monthlyExpenses = student.totalExpensesThisMonth()
        let fixedCategories = ["Rent", "Tuition", "Residence", "Meal Plan", "Phone", "Internet", "Insurance"]
        let categoryTotals = student.expensesByCategory()
        let fixedTotal = categoryTotals.filter { fixedCategories.contains($0.key) }.reduce(0) { $0 + $1.value }
        let variableTotal = max(0, monthlyExpenses - fixedTotal)
        let denom = max(1, monthlyExpenses)
        let topCategory = categoryTotals.max(by: { $0.value < $1.value })?.key ?? "None"
        let topAmount = categoryTotals.max(by: { $0.value < $1.value })?.value ?? 0
        return SpendingTrendSummary(
            monthIncome: monthlyIncome,
            monthExpenses: monthlyExpenses,
            fixedExpensePercentage: (fixedTotal / denom) * 100,
            variableExpensePercentage: (variableTotal / denom) * 100,
            topCategory: topCategory,
            topCategoryAmount: topAmount
        )
    }

    // MARK: - Safety Warnings

    func safetyWarnings(for studentId: String) -> [FinancialAlert] {
        guard let student = repository.findStudent(byId: studentId),
              let plan = student.semesterPlan else { return [] }
        var alerts: [FinancialAlert] = []
        if let runway = semesterRunway(for: studentId) {
            if runway.safeWeeklySpending < 0 {
                alerts.append(FinancialAlert(title: "Critical runway", message: "At the current plan, expenses exceed available funds before the semester ends.", severity: .critical))
            } else if runway.safeWeeklySpending < 60 {
                alerts.append(FinancialAlert(title: "Low weekly runway", message: "Warning: At current spending rate, your discretionary budget is very tight.", severity: .warning))
            }
        }
        let next30Days = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        let upcomingOutgoing = plan.upcomingPayments.filter { !$0.isIncoming && $0.dueDate <= next30Days }.reduce(0) { $0 + $1.amount }
        if student.balance() < upcomingOutgoing {
            alerts.append(FinancialAlert(title: "Upcoming bills exceed balance", message: "Alert: Tuition + rent + food in the next month exceed current balance.", severity: .critical))
        }
        if alerts.isEmpty {
            alerts.append(FinancialAlert(title: "Stable outlook", message: "No urgent financial warning detected right now.", severity: .info))
        }
        return alerts
    }

    // MARK: - York Tips

    func yorkSpecificTips() -> [YorkTip] {
        [
            YorkTip(message: "Use York bookstore resale options or used textbook groups to reduce textbook costs."),
            YorkTip(message: "Compare TTC student fares and GO student savings if you commute multiple days each week."),
            YorkTip(message: "Review OSAP release timing before major tuition deadlines so your runway stays realistic.")
        ]
    }

    // MARK: - Recurrence

    private func handleRecurrence(for student: Student, amount: Double, category: String,
                                   type: String, startDate: Date, recurrence: Recurrence) {
        guard recurrence != .none else { return }
        let cal = Calendar.current
        var nextDate = startDate
        for _ in 1...12 {
            switch recurrence {
            case .weekly:    nextDate = cal.date(byAdding: .weekOfYear, value: 1,  to: nextDate) ?? nextDate
            case .biweekly:  nextDate = cal.date(byAdding: .weekOfYear, value: 2,  to: nextDate) ?? nextDate
            case .monthly:   nextDate = cal.date(byAdding: .month,      value: 1,  to: nextDate) ?? nextDate
            case .none: break
            }
            let tx = Transaction(id: UUID().uuidString, amount: amount, date: nextDate, type: type, category: category)
            student.transactions.append(tx)
        }
        repository.saveStudent(student)
    }
}
