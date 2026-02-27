
//
//  ContentView.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
// edited by gurshaan gill

import SwiftUI

// MARK: - Recurrence Enum
// Enum to define how often a transaction repeats
enum Recurrence: String, CaseIterable, Identifiable {
    case none, weekly, biweekly, monthly
    
    // Conformance to Identifiable protocol
    var id: String { self.rawValue }
}

// MARK: - Main Content View
struct ContentView: View {
    // StateObject manages the lifecycle of the repository for this view
    @StateObject private var repository = StudentRepositoryStub()
    
    // Service handles business logic, like adding income/expense
    private var service: FinancialService
    
    // Input fields for adding a transaction
    @State private var amountText = ""          // Text input for amount
    @State private var categoryText = ""        // Text input for category/title
    @State private var recurrenceSelection: Recurrence = .none  // Picker selection
    
    // Custom initializer to inject repository into service
    init() {
        let repo = StudentRepositoryStub()
        self._repository = StateObject(wrappedValue: repo)
        self.service = FinancialService(repository: repo)
    }

    // MARK: - Body
    var body: some View {
        TabView {  // Tab bar navigation
            mainHomeView
                .tabItem { Label("Home", systemImage: "house.fill") }

            addTransactionView
                .tabItem { Label("Add", systemImage: "plus.circle.fill") }

            budgetView
                .tabItem { Label("Budget", systemImage: "chart.bar.fill") }
        }
    }

    // MARK: - Home View
    private var mainHomeView: some View {
        ZStack {
            Color.blue.opacity(0.55).ignoresSafeArea()  // Background color
            ScrollView {  // Scrollable content
                VStack(spacing: 25) {
                    Text("UniWallet")  // App title
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top)

                    // Display student financial data if available
                    if let student = repository.findStudent(byId: "S001") {
                        HStack(spacing: 15) {
                            // Cards showing Income, Expenses, Balance
                            cuteCard(title: "Income", amount: student.totalIncome(), color: .green, icon: "arrow.up.circle.fill")
                            cuteCard(title: "Expenses", amount: student.totalExpenses(), color: .red, icon: "arrow.down.circle.fill")
                            cuteCard(title: "Balance", amount: student.balance(), color: .blue, icon: "banknote.fill")
                        }
                        .padding(.top)
                        .padding(.horizontal)

                        // List of all transactions
                        transactionListView(student: student)
                    }
                    Spacer()
                }
                .padding(.bottom)
            }
        }
    }

    // MARK: - Add Transaction View
    private var addTransactionView: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea() // Background color
            VStack(spacing: 20) {
                // Amount input field
                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)

                // Category / Title input field
                TextField("Category / Title", text: $categoryText)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)

                // Recurrence picker
                Picker("Repeat", selection: $recurrenceSelection) {
                    ForEach(Recurrence.allCases) { rec in
                        Text(rec.rawValue.capitalized).tag(rec)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                // Buttons for adding income or expense
                HStack(spacing: 15) {
                    // Add Income
                    Button(action: {
                        if let amount = Double(amountText) {
                            service.addIncome(studentId: "S001", amount: amount, category: categoryText, recurrence: recurrenceSelection)
                            clearInputs()  // Reset fields after adding
                        }
                    }) {
                        Label("Income", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }

                    // Add Expense
                    Button(action: {
                        if let amount = Double(amountText) {
                            service.addExpense(studentId: "S001", amount: amount, category: categoryText, recurrence: recurrenceSelection)
                            clearInputs()  // Reset fields after adding
                        }
                    }) {
                        Label("Expense", systemImage: "minus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Budget / Projection View
    private var budgetView: some View {
        ZStack {
            Color.orange.opacity(0.2).ignoresSafeArea() // Background color
            VStack(spacing: 20) {
                // Calculate monthly totals if student exists
                if let student = repository.findStudent(byId: "S001") {
                    let income = student.totalIncomeThisMonth()
                    let expenses = student.totalExpensesThisMonth()
                    let net = income - expenses
                    let projectedBalance = student.balance() + net

                    Text("This Month")
                        .font(.title)
                        .bold()

                    Text("Income: $\(income, specifier: "%.2f")")
                    Text("Expenses: $\(expenses, specifier: "%.2f")")
                    Text("Net: $\(net, specifier: "%.2f")")
                        .foregroundColor(net >= 0 ? .green : .red)
                        .bold()

                    Divider().padding()

                    Text("Projected Next Month Balance: $\(projectedBalance, specifier: "%.2f")")
                        .foregroundColor(projectedBalance >= 0 ? .green : .red)
                        .bold()
                } else {
                    Text("No student data found")
                }
            }
            .padding()
        }
    }

    // MARK: - Transactions List View
    private func transactionListView(student: Student) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Transactions")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 20)

            // Loop through transactions and display each
            ForEach(student.transactions.indices, id: \.self) { i in
                let t = student.transactions[i]
                HStack {
                    Text(t.category)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                    Spacer()
                    Text(t.type == "Income" ? "+$\(t.amount, specifier: "%.2f")" : "-$\(t.amount, specifier: "%.2f")")
                        .foregroundColor(t.type == "Income" ? .green : .red)
                        .bold()
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(25)
                .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Helpers
    // Creates a small card for displaying income, expenses, or balance
    private func cuteCard(title: String, amount: Double, color: Color, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.gray)
            Text("$\(amount, specifier: "%.2f")")
                .font(.system(size: 18, weight: .bold, design: .rounded))
        }
        .frame(width: 100, height: 120)
        .background(Color.white.opacity(0.8))
        .cornerRadius(25)
        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 3)
    }

    // Clears input fields after adding a transaction
    private func clearInputs() {
        amountText = ""
        categoryText = ""
        recurrenceSelection = .none
    }
}

// MARK: - Extensions for monthly totals
extension Student {
    // Calculates total income for current month
    func totalIncomeThisMonth() -> Double {
        let calendar = Calendar.current
        let now = Date()
        return transactions.filter {
            $0.type == "Income" && calendar.isDate($0.date, equalTo: now, toGranularity: .month)
        }.reduce(0) { $0 + $1.amount }
    }

    // Calculates total expenses for current month
    func totalExpensesThisMonth() -> Double {
        let calendar = Calendar.current
        let now = Date()
        return transactions.filter {
            $0.type == "Expense" && calendar.isDate($0.date, equalTo: now, toGranularity: .month)
        }.reduce(0) { $0 + $1.amount }
    }
}


