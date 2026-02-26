import SwiftUI

struct ContentView: View {
    @StateObject private var repository = StudentRepositoryStub()
    private var service: FinancialService

    @State private var amountText = ""
    @State private var categoryText = ""

    init() {
        let repo = StudentRepositoryStub()
        self._repository = StateObject(wrappedValue: repo)
        self.service = FinancialService(repository: repo)
    }

    var body: some View {
        ZStack {
            // Light blue background
            Color.blue.opacity(0.45)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 25) {

                    // MARK: - App Header
                    Text("UniWallet")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top)

                    // MARK: - Summary Cards
                    if let student = repository.findStudent(byId: "S001") {
                        HStack(spacing: 15) {
                            cuteCard(title: "Income", amount: student.totalIncome(), color: .green, icon: "arrow.up.circle.fill")
                            cuteCard(title: "Expenses", amount: student.totalExpenses(), color: .red, icon: "arrow.down.circle.fill")
                            cuteCard(title: "Balance", amount: student.balance(), color: .blue, icon: "banknote.fill")
                        }
                        .padding(.top)
                        .padding(.horizontal)

                        // MARK: - Input Section
                        VStack(spacing: 15) {
                            TextField("Amount", text: $amountText)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(20)
                                .font(.system(size: 18, weight: .medium, design: .rounded))

                            TextField("Category", text: $categoryText)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(20)
                                .font(.system(size: 18, weight: .medium, design: .rounded))

                            HStack(spacing: 15) {
                                Button(action: {
                                    if let amount = Double(amountText) {
                                        service.addIncome(studentId: "S001", amount: amount, category: categoryText)
                                        amountText = ""
                                        categoryText = ""
                                    }
                                }) {
                                    Label("Income", systemImage: "plus.circle.fill")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(25)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                }

                                Button(action: {
                                    if let amount = Double(amountText) {
                                        service.addExpense(studentId: "S001", amount: amount, category: categoryText)
                                        amountText = ""
                                        categoryText = ""
                                    }
                                }) {
                                    Label("Expense", systemImage: "minus.circle.fill")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.pink.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(25)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)

                        // MARK: - Transaction List
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Transactions")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.top, 20)

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

                    Spacer()
                }
                .padding(.bottom)
            }
        }
    }

    // MARK: - Cute Summary Card
    @ViewBuilder
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
