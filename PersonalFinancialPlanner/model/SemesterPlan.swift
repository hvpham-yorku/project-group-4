//
//  SemesterPlan.swift
//  PersonalFinancialPlanner
//
//  Created by Mehrshad Zarastounia on 2026-03-14.
//

import Foundation

enum CommuteType: String, Codable, CaseIterable {
    case commuter
    case residence
}

struct UpcomingPayment: Identifiable, Codable {
    let id: String
    let title: String
    let amount: Double
    let dueDate: Date
    let isIncoming: Bool
    
    init(
        id: String = UUID().uuidString,
        title: String,
        amount: Double,
        dueDate: Date,
        isIncoming: Bool
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.dueDate = dueDate
        self.isIncoming = isIncoming
    }
}

struct SemesterPlan: Codable {
    var semesterName: String
    var startDate: Date
    var endDate: Date
    
    var tuitionDueDate: Date
    var tuitionAmount: Double
    
    var osapExpectedDate: Date
    var osapAmount: Double
    
    var monthlyRent: Double
    var mealPlanBalance: Double
    
    var weeklyTTC: Double
    var weeklyGOTransit: Double
    
    var nextPaycheckDate: Date
    var nextPaycheckAmount: Double
    
    var commuteType: CommuteType
    
    var upcomingPayments: [UpcomingPayment]
}

enum AlertSeverity: String, Codable {
    case info
    case warning
    case critical
}

struct FinancialAlert: Identifiable, Codable {
    let id: String
    let title: String
    let message: String
    let severity: AlertSeverity
    
    init(
        id: String = UUID().uuidString,
        title: String,
        message: String,
        severity: AlertSeverity
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.severity = severity
    }
}

struct SemesterRunwaySummary {
    let remainingBalance: Double
    let safeWeeklySpending: Double
    let weeksRemaining: Int
    let endDate: Date
}

struct SpendingTrendSummary {
    let monthIncome: Double
    let monthExpenses: Double
    let fixedExpensePercentage: Double
    let variableExpensePercentage: Double
    let topCategory: String
    let topCategoryAmount: Double
}

struct WhatIfResult {
    let newSafeWeeklySpending: Double
    let runwayDaysReduced: Int
}

struct ResidenceMealPlanSummary {
    let residencePaid: Double
    let remainingMealPlan: Double
    let safeWeeklyFoodSpending: Double
}

struct CommuterCostSummary {
    let weeklyTTC: Double
    let weeklyGOTransit: Double
    let transportationBudgetShare: Double
}

struct YorkTip: Identifiable {
    let id = UUID()
    let message: String
}
