//
//  ContentView.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//

import SwiftUI

struct ContentView: View {
    private let repository: StudentRepositoryStub
    private let service: FinancialService

    // Initialize repository and service
    init() {
        let repo = StudentRepositoryStub()
        self.repository = repo
        self.service = FinancialService(repository: repo)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Personal Financial Planner")
                .font(.largeTitle)
                .padding(.bottom)

            // Financial summary
            if let student = repository.findStudent(byId: "S001") {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Student: \(student.name)")
                        .font(.headline)
                    Text("Total Income: $\(student.totalIncome(), specifier: "%.2f")")
                    Text("Total Expenses: $\(student.totalExpenses(), specifier: "%.2f")")
                    Text("Remaining Balance: $\(student.balance(), specifier: "%.2f")")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }

            // Buttons to add income / expense
            HStack {
                Button("Add Income") {
                    service.addIncome(studentId: "S001", amount: 200, category: "Part-Time Job")
                }
                .padding()
                .background(Color.green.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Add Expense") {
                    service.addExpense(studentId: "S001", amount: 50, category: "Food")
                }
                .padding()
                .background(Color.red.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            Divider()

            // Expenses by category (your requested VStack)
            VStack(alignment: .leading) {
                Text("Expenses by Category")
                    .font(.headline)
                if let student = repository.findStudent(byId: "S001") {
                    ForEach(Array(student.expensesByCategory()), id: \.key) { category, amount in
                        Text("\(category): $\(amount, specifier: "%.2f")")
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
