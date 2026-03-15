//
//  ContentView.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//  Edited by Gurshaan Gill and Mehrshad Zarastounia
//
import SwiftUI

enum Recurrence: String, CaseIterable, Identifiable {
    case none
    case weekly
    case biweekly
    case monthly
    
    var id: String { rawValue }
}

struct ContentView<RepositoryType: StudentRepository & ObservableObject>: View {
    
    @ObservedObject var repository: RepositoryType
    private let service: FinancialService
    
    @State private var amountText = ""
    @State private var categoryText = ""
    @State private var recurrenceSelection: Recurrence = .none
    @State private var whatIfAmount = "120"
    
    init(repository: RepositoryType) {
        self.repository = repository
        self.service = FinancialService(repository: repository)
    }
    
    var body: some View {
        TabView {
            dashboardView
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            addTransactionView
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
            
            trendsView
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.fill")
                }
        }
    }
    
    private var dashboardView: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("UniWallet")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("A predictive, semester-based financial planner for York students.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.75))
                        
                        if let student = repository.findStudent(byId: "S001") {
                            summaryCards(student: student)
                            
                            if let runway = service.semesterRunway(for: "S001") {
                                dashboardCard(title: "Semester Runway", icon: "calendar.badge.clock") {
                                    Text("You have $\(runway.remainingBalance, specifier: "%.0f") remaining for the semester.")
                                    Text("Safe weekly spending: $\(runway.safeWeeklySpending, specifier: "%.0f")/week")
                                    Text("Weeks remaining: \(runway.weeksRemaining)")
                                }
                            }
                            
                            dashboardCard(title: "Upcoming Payments / Deadlines", icon: "exclamationmark.circle") {
                                ForEach(service.upcomingPayments(for: "S001")) { payment in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(payment.title)
                                                .font(.headline)
                                            Text(formattedDate(payment.dueDate))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Text("\(payment.isIncoming ? "+" : "-")$\(payment.amount, specifier: "%.0f")")
                                            .foregroundColor(payment.isIncoming ? .green : .red)
                                            .bold()
                                    }
                                }
                            }
                            
                            if let commuter = service.commuterCosts(for: "S001") {
                                dashboardCard(title: "Commuter Costs", icon: "tram.fill") {
                                    Text("This week: TTC $\(commuter.weeklyTTC, specifier: "%.0f"), GO Transit $\(commuter.weeklyGOTransit, specifier: "%.0f").")
                                    Text("Transportation makes up \(commuter.transportationBudgetShare, specifier: "%.0f")% of weekly budget.")
                                }
                            }
                            
                            if let residence = service.residenceMealPlanSummary(for: "S001") {
                                dashboardCard(title: "Residence / Meal Plan Costs", icon: "fork.knife") {
                                    Text("Residence fees paid: $\(residence.residencePaid, specifier: "%.0f")")
                                    Text("Remaining meal plan balance: $\(residence.remainingMealPlan, specifier: "%.0f")")
                                    Text("Safe weekly food spending: $\(residence.safeWeeklyFoodSpending, specifier: "%.0f")")
                                }
                            }
                            
                            dashboardCard(title: "What-If Alert", icon: "questionmark.circle.fill") {
                                if let amount = Double(whatIfAmount),
                                   let result = service.whatIfExpenseImpact(for: "S001", extraExpense: amount) {
                                    Text("Buying a $\(amount, specifier: "%.0f") item reduces safe weekly spending to $\(result.newSafeWeeklySpending, specifier: "%.0f").")
                                    Text("Runway shortens by \(result.runwayDaysReduced) days.")
                                }
                                
                                TextField("What-if amount", text: $whatIfAmount)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            if let paycheck = service.nextPaycheckSummary(for: "S001") {
                                dashboardCard(title: "Co-op / Part-Time Income", icon: "dollarsign.circle.fill") {
                                    Text(paycheck)
                                }
                            }
                            
                            dashboardCard(title: "Safety Warnings", icon: "exclamationmark.triangle.fill") {
                                ForEach(service.safetyWarnings(for: "S001")) { alert in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(alert.title)
                                            .font(.headline)
                                            .foregroundColor(color(for: alert.severity))
                                        Text(alert.message)
                                    }
                                    .padding(.bottom, 6)
                                }
                            }
                            
                            dashboardCard(title: "York-Specific Tips", icon: "lightbulb.fill") {
                                ForEach(service.yorkSpecificTips()) { tip in
                                    Text("• \(tip.message)")
                                }
                            }
                            
                            transactionListView(student: student)
                        } else {
                            Text("No student data found")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var addTransactionView: some View {
        ZStack {
            Color.gray.opacity(0.15).ignoresSafeArea()
            
            VStack(spacing: 20) {
                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(14)
                
                TextField("Category / Title", text: $categoryText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(14)
                
                Picker("Repeat", selection: $recurrenceSelection) {
                    ForEach(Recurrence.allCases) { recurrence in
                        Text(recurrence.rawValue.capitalized).tag(recurrence)
                    }
                }
                .pickerStyle(.segmented)
                
                HStack(spacing: 14) {
                    Button {
                        if let amount = Double(amountText), !categoryText.trimmingCharacters(in: .whitespaces).isEmpty {
                            service.addIncome(studentId: "S001", amount: amount, category: categoryText, recurrence: recurrenceSelection)
                            clearInputs()
                        }
                    } label: {
                        Label("Income", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    
                    Button {
                        if let amount = Double(amountText), !categoryText.trimmingCharacters(in: .whitespaces).isEmpty {
                            service.addExpense(studentId: "S001", amount: amount, category: categoryText, recurrence: recurrenceSelection)
                            clearInputs()
                        }
                    } label: {
                        Label("Expense", systemImage: "minus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private var trendsView: some View {
        ZStack {
            Color.blue.opacity(0.08).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Spending Trends")
                    .font(.largeTitle.bold())
                
                if let trend = service.spendingTrend(for: "S001") {
                    dashboardCardLight(title: "Monthly Summary", icon: "chart.bar.fill") {
                        Text("Income this month: $\(trend.monthIncome, specifier: "%.0f")")
                        Text("Expenses this month: $\(trend.monthExpenses, specifier: "%.0f")")
                        Text("Top category: \(trend.topCategory) ($\(trend.topCategoryAmount, specifier: "%.0f"))")
                    }
                    
                    dashboardCardLight(title: "Expense Mix", icon: "chart.pie.fill") {
                        Text("Fixed expenses: \(trend.fixedExpensePercentage, specifier: "%.0f")%")
                        Text("Variable expenses: \(trend.variableExpensePercentage, specifier: "%.0f")%")
                    }
                } else {
                    Text("No insight data available.")
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func summaryCards(student: Student) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                compactCard(title: "Income", value: student.totalIncome(), color: .green)
                compactCard(title: "Expenses", value: student.totalExpenses(), color: .red)
                compactCard(title: "Balance", value: student.balance(), color: .blue)
            }
        }
    }
    
    private func compactCard(title: String, value: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.white.opacity(0.7))
            Text("$\(value, specifier: "%.0f")")
                .font(.title2.bold())
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 150, alignment: .leading)
        .background(color.opacity(0.85))
        .cornerRadius(18)
    }
    
    private func dashboardCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(.white)
            content()
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.09))
        .cornerRadius(18)
    }
    
    private func dashboardCardLight<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.headline)
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(radius: 4)
    }
    
    private func transactionListView(student: Student) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Transactions")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            ForEach(student.transactions.indices, id: \.self) { index in
                let transaction = student.transactions[index]
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(transaction.category)
                            .foregroundColor(.white)
                        Text(formattedDate(transaction.date))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                    Text(transaction.type == "Income"
                         ? "+$\(transaction.amount, specifier: "%.0f")"
                         : "-$\(transaction.amount, specifier: "%.0f")")
                        .foregroundColor(transaction.type == "Income" ? .green : .red)
                        .bold()
                }
                .padding()
                .background(Color.white.opacity(0.08))
                .cornerRadius(14)
            }
        }
    }
    
    private func color(for severity: AlertSeverity) -> Color {
        switch severity {
        case .info: return .blue
        case .warning: return .yellow
        case .critical: return .red
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func clearInputs() {
        amountText = ""
        categoryText = ""
        recurrenceSelection = .none
    }
}

extension Student {
    
    func totalIncomeThisMonth() -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        return transactions
            .filter { $0.type == "Income" && calendar.isDate($0.date, equalTo: now, toGranularity: .month) }
            .reduce(0) { $0 + $1.amount }
    }
    
    func totalExpensesThisMonth() -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        return transactions
            .filter { $0.type == "Expense" && calendar.isDate($0.date, equalTo: now, toGranularity: .month) }
            .reduce(0) { $0 + $1.amount }
    }
}
