import SwiftUI
import Foundation

// MARK: - Recurrence

enum Recurrence: String, CaseIterable, Identifiable {
    case none
    case weekly
    case biweekly
    case monthly

    var id: String { rawValue }
}

// MARK: - Content View

struct ContentView<RepositoryType: StudentRepository & ObservableObject>: View {
    @ObservedObject var repository: RepositoryType
    private let service: FinancialService

    @State private var amountText = ""
    @State private var categoryText = ""
    @State private var recurrenceSelection: Recurrence = .none
    @State private var whatIfAmount = "120"

    private let currentStudentId = "S001"

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

    // MARK: - Dashboard
    private var dashboardView: some View {
        VStack(spacing: 20) {
            Text("UniWallet")
                .font(.largeTitle.bold())

            if let student = repository.findStudent(byId: currentStudentId) {
                Text("Balance: $\(student.balance(), specifier: "%.2f")")
                    .font(.title2)

                List(student.transactions) { tx in
                    HStack {
                        Text(tx.category)
                        Spacer()
                        Text(
                            (tx.type == "Income" ? "+" : "-") +
                            String(format: "$%.2f", tx.amount)
                        )
                    }
                }
            }
        }
        .padding()
    }

    // MARK: - Add Transaction
    private var addTransactionView: some View {
        VStack(spacing: 16) {
            TextField("Amount", text: $amountText)
                .textFieldStyle(.roundedBorder)

            TextField("Category", text: $categoryText)
                .textFieldStyle(.roundedBorder)

            Picker("Repeat", selection: $recurrenceSelection) {
                ForEach(Recurrence.allCases) { recurrence in
                    Text(recurrence.rawValue.capitalized).tag(recurrence)
                }
            }
            .pickerStyle(.segmented)

            Button("Add Expense") {
                if let amount = Double(amountText),
                   let student = repository.findStudent(byId: currentStudentId) {
                    service.addExpense(student: student, amount: amount, category: categoryText)
                    amountText = ""
                    categoryText = ""
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    // MARK: - Trends
    private var trendsView: some View {
        VStack(spacing: 20) {
            Text("Insights")
                .font(.largeTitle.bold())

            if let student = repository.findStudent(byId: currentStudentId) {
                Text("Transactions: \(student.transactions.count)")
                Text("What-if amount: $\(whatIfAmount)")
            }
        }
        .padding()
    }
}
