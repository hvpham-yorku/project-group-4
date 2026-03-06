//
//  ContentView.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//  Edited by Gurshaan Gill and Mehrshad Zarastounia
//

import SwiftUI

// Defines how often a transaction repeats
enum Recurrence: String, CaseIterable, Identifiable {
    case none
    case weekly
    case biweekly
    case monthly
    
    var id: String { rawValue }
}

// Main content view
struct ContentView<RepositoryType: StudentRepository & ObservableObject>: View {
    
    // Repository injected from the app entry point
    @ObservedObject var repository: RepositoryType
    
    // Business logic service
    private let service: FinancialService
    
    // Input fields
    @State private var amountText = ""
    @State private var categoryText = ""
    @State private var recurrenceSelection: Recurrence = .none
    
    // Inject repository and create the service from it
    init(repository: RepositoryType) {
        self.repository = repository
        self.service = FinancialService(repository: repository)
    }
    
    var body: some View {
        TabView {
            mainHomeView
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            addTransactionView
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
            
            budgetView
                .tabItem {
                    Label("Budget", systemImage: "chart.bar.fill")
                }
        }
    }
    
    // MARK: - Home View
    private var mainHomeView: some View {
        ZStack {
            Color.blue.opacity(0.55)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("UniWallet")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    if let student = repository.findStudent(byId: "S001") {
                        HStack(spacing: 15) {
                            cuteCard(
                                title: "Income",
                                amount: student.totalIncome(),
                                color: .green,
                                icon: "arrow.up.circle.fill"
                            )
                            
                            cuteCard(
                                title: "Expenses",
                                amount: student.totalExpenses(),
                                color: .red,
                                icon: "arrow.down.circle.fill"
                            )
                            
                            cuteCard(
                                title: "Balance",
                                amount: student.balance(),
                                color: .blue,
                                icon: "banknote.fill"
                            )
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        
                        transactionListView(student: student)
                    } else {
                        Text("No student data found")
                            .foregroundColor(.white)
                            .font(.headline)
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
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                
                TextField("Category / Title", text: $categoryText)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                
                Picker("Repeat", selection: $recurrenceSelection) {
                    ForEach(Recurrence.allCases) { recurrence in
                        Text(recurrence.rawValue.capitalized).tag(recurrence)
                    }
                }
                .pickerStyle(.segmented)
                
                HStack(spacing: 15) {
                    Button {
                        if let amount = Double(amountText), !categoryText.trimmingCharacters(in: .whitespaces).isEmpty {
                            service.addIncome(
                                studentId: "S001",
                                amount: amount,
                                category: categoryText,
                                recurrence: recurrenceSelection
                            )
                            clearInputs()
                        }
                    } label: {
                        Label("Income", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    
                    Button {
                        if let amount = Double(amountText), !categoryText.trimmingCharacters(in: .whitespaces).isEmpty {
                            service.addExpense(
                                studentId: "S001",
                                amount: amount,
                                category: categoryText,
                                recurrence: recurrenceSelection
                            )
                            clearInputs()
                        }
                    } label: {
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
    
    // MARK: - Budget View
    private var budgetView: some View {
        ZStack {
            Color.orange.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
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
    
    // MARK: - Transactions List
    private func transactionListView(student: Student) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Transactions")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 20)
            
            ForEach(student.transactions.indices, id: \.self) { index in
                let transaction = student.transactions[index]
                
                HStack {
                    Text(transaction.category)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(
                        transaction.type == "Income"
                        ? "+$\(transaction.amount, specifier: "%.2f")"
                        : "-$\(transaction.amount, specifier: "%.2f")"
                    )
                    .foregroundColor(transaction.type == "Income" ? .green : .red)
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
    
    // MARK: - Helper Card
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
    
    // Clears form input fields
    private func clearInputs() {
        amountText = ""
        categoryText = ""
        recurrenceSelection = .none
    }
}

// MARK: - Student Extensions
extension Student {
    
    // Returns total income for the current month
    func totalIncomeThisMonth() -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        return transactions
            .filter { $0.type == "Income" && calendar.isDate($0.date, equalTo: now, toGranularity: .month) }
            .reduce(0) { $0 + $1.amount }
    }
    
    // Returns total expenses for the current month
    func totalExpensesThisMonth() -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        return transactions
            .filter { $0.type == "Expense" && calendar.isDate($0.date, equalTo: now, toGranularity: .month) }
            .reduce(0) { $0 + $1.amount }
    }
}
