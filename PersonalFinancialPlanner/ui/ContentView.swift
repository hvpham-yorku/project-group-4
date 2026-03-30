import SwiftUI
import Combine

// MARK: - Recurrence

enum Recurrence: String, CaseIterable, Identifiable {
    case none, weekly, biweekly, monthly
    var id: String { rawValue }
}

// MARK: - Category Model

struct TransactionCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let type: CategoryType
    enum CategoryType { case income, expense, both }
}

let predefinedCategories: [TransactionCategory] = [
    TransactionCategory(name: "OSAP",          icon: "building.columns.fill",  color: Color(red: 0.2,  green: 0.85, blue: 0.55), type: .income),
    TransactionCategory(name: "Part-time Job", icon: "briefcase.fill",          color: Color(red: 0.2,  green: 0.75, blue: 0.45), type: .income),
    TransactionCategory(name: "Co-op",         icon: "laptopcomputer",          color: Color(red: 0.15, green: 0.65, blue: 0.80), type: .income),
    TransactionCategory(name: "Scholarship",   icon: "star.fill",               color: Color(red: 1.0,  green: 0.75, blue: 0.2),  type: .income),
    TransactionCategory(name: "Family",        icon: "house.fill",              color: Color(red: 0.55, green: 0.45, blue: 0.95), type: .income),
    TransactionCategory(name: "Freelance",     icon: "pencil.and.ruler.fill",   color: Color(red: 0.3,  green: 0.70, blue: 0.90), type: .income),
    TransactionCategory(name: "Food",          icon: "fork.knife",              color: Color(red: 1.0,  green: 0.55, blue: 0.2),  type: .expense),
    TransactionCategory(name: "Groceries",     icon: "cart.fill",               color: Color(red: 0.9,  green: 0.45, blue: 0.3),  type: .expense),
    TransactionCategory(name: "Rent",          icon: "bed.double.fill",         color: Color(red: 1.0,  green: 0.38, blue: 0.38), type: .expense),
    TransactionCategory(name: "Tuition",       icon: "graduationcap.fill",      color: Color(red: 0.9,  green: 0.30, blue: 0.45), type: .expense),
    TransactionCategory(name: "Transport",     icon: "tram.fill",               color: Color(red: 0.4,  green: 0.60, blue: 1.0),  type: .expense),
    TransactionCategory(name: "Books",         icon: "books.vertical.fill",     color: Color(red: 0.55, green: 0.40, blue: 0.80), type: .expense),
    TransactionCategory(name: "Coffee",        icon: "cup.and.saucer.fill",     color: Color(red: 0.75, green: 0.50, blue: 0.30), type: .expense),
    TransactionCategory(name: "Health",        icon: "cross.fill",              color: Color(red: 1.0,  green: 0.35, blue: 0.55), type: .expense),
    TransactionCategory(name: "Phone",         icon: "iphone",                  color: Color(red: 0.45, green: 0.55, blue: 0.95), type: .expense),
    TransactionCategory(name: "Internet",      icon: "wifi",                    color: Color(red: 0.30, green: 0.65, blue: 0.95), type: .expense),
    TransactionCategory(name: "Entertainment", icon: "gamecontroller.fill",     color: Color(red: 0.85, green: 0.35, blue: 0.75), type: .expense),
    TransactionCategory(name: "Clothing",      icon: "tshirt.fill",             color: Color(red: 0.70, green: 0.40, blue: 0.60), type: .expense),
    TransactionCategory(name: "Gym",           icon: "figure.run",              color: Color(red: 0.30, green: 0.75, blue: 0.55), type: .expense),
    TransactionCategory(name: "Other",         icon: "ellipsis.circle.fill",    color: Color(red: 0.55, green: 0.55, blue: 0.55), type: .both),
]

// MARK: - Category Grid Picker

struct CategoryGridPicker: View {
    let isIncome: Bool
    @Binding var selected: TransactionCategory?
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    private var filtered: [TransactionCategory] {
        predefinedCategories.filter { $0.type == .both || (isIncome ? $0.type == .income : $0.type == .expense) }
    }
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(filtered) { cat in
                let isSelected = selected?.id == cat.id
                Button {
                    withAnimation(.spring(response: 0.25)) { selected = isSelected ? nil : cat }
                } label: {
                    VStack(spacing: 6) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isSelected ? cat.color : cat.color.opacity(0.12))
                                .frame(width: 48, height: 48)
                            Image(systemName: cat.icon)
                                .font(.system(size: 18))
                                .foregroundColor(isSelected ? .black : cat.color)
                        }
                        Text(cat.name)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                            .lineLimit(1).minimumScaleFactor(0.7)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Calendar Month View

struct CalendarMonthView: View {
    @Binding var selectedDate: Date
    let transactions: [Transaction]
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                } label: {
                    Image(systemName: "chevron.left").font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8)).frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.1)).clipShape(Circle())
                }
                Spacer()
                Text(monthYearString(selectedDate))
                    .font(.system(size: 15, weight: .semibold, design: .rounded)).foregroundColor(.white)
                Spacer()
                Button {
                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                } label: {
                    Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8)).frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.1)).clipShape(Circle())
                }
            }
            .padding(.horizontal, 4).padding(.bottom, 12)

            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day).font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.45)).frame(maxWidth: .infinity)
                }
            }.padding(.bottom, 6)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isToday: calendar.isDateInToday(date),
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            incomeAmount: incomeFor(date: date),
                            expenseAmount: expenseFor(date: date)
                        ).onTapGesture { selectedDate = date }
                    } else { Color.clear.frame(height: 36) }
                }
            }
        }
        .padding(16).background(Color.white.opacity(0.07)).cornerRadius(20)
    }

    private func daysInMonth() -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))
        else { return [] }
        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        for day in range { days.append(calendar.date(byAdding: .day, value: day - 1, to: firstDay)) }
        while days.count % 7 != 0 { days.append(nil) }
        return days
    }

    private func incomeFor(date: Date) -> Double {
        transactions.filter { $0.type == "Income" && calendar.isDate($0.date, inSameDayAs: date) }.reduce(0) { $0 + $1.amount }
    }
    private func expenseFor(date: Date) -> Double {
        transactions.filter { $0.type == "Expense" && calendar.isDate($0.date, inSameDayAs: date) }.reduce(0) { $0 + $1.amount }
    }
    private func monthYearString(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "MMMM yyyy"; return f.string(from: date)
    }
}

// MARK: - Day Cell

struct DayCell: View {
    let date: Date; let isToday: Bool; let isSelected: Bool
    let incomeAmount: Double; let expenseAmount: Double
    private let calendar = Calendar.current
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                if isSelected { Circle().fill(Color.white).frame(width: 28, height: 28) }
                else if isToday { Circle().stroke(Color.white.opacity(0.6), lineWidth: 1.2).frame(width: 28, height: 28) }
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 12, weight: isToday || isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .black : .white.opacity(isToday ? 1 : 0.8))
            }.frame(width: 28, height: 28)
            HStack(spacing: 2) {
                if incomeAmount > 0 { Circle().fill(Color(red: 0.2, green: 0.85, blue: 0.55)).frame(width: 4, height: 4) }
                if expenseAmount > 0 { Circle().fill(Color(red: 1.0, green: 0.38, blue: 0.38)).frame(width: 4, height: 4) }
            }.frame(height: 5)
        }.frame(maxWidth: .infinity)
    }
}

// MARK: - Edit Transaction Sheet

struct EditTransactionSheet: View {
    let transaction: Transaction
    var onSave: (Transaction) -> Void
    var onDelete: () -> Void

    @State private var amountText: String
    @State private var selectedCategory: TransactionCategory?
    @State private var customCategory: String
    @State private var selectedDate: Date
    @State private var isIncome: Bool
    @Environment(\.dismiss) private var dismiss

    init(transaction: Transaction, onSave: @escaping (Transaction) -> Void, onDelete: @escaping () -> Void) {
        self.transaction = transaction
        self.onSave = onSave
        self.onDelete = onDelete
        _amountText = State(initialValue: String(format: "%.0f", transaction.amount))
        _selectedDate = State(initialValue: transaction.date)
        _isIncome = State(initialValue: transaction.type == "Income")
        let match = predefinedCategories.first { $0.name == transaction.category }
        _selectedCategory = State(initialValue: match ?? predefinedCategories.first { $0.name == "Other" })
        _customCategory = State(initialValue: match == nil ? transaction.category : "")
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.06, green: 0.07, blue: 0.12), Color(red: 0.08, green: 0.10, blue: 0.18)],
                           startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack {
                        Text("Edit Transaction")
                            .font(.system(size: 24, weight: .bold, design: .rounded)).foregroundColor(.white)
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark").font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6)).frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.1)).clipShape(Circle())
                        }
                    }.padding(.top, 8)

                    // Type toggle
                    HStack(spacing: 0) {
                        Button { withAnimation { isIncome = true; selectedCategory = nil } } label: {
                            Text("Income").font(.system(size: 14, weight: .semibold))
                                .foregroundColor(isIncome ? .black : .white.opacity(0.5))
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(isIncome ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color.clear).cornerRadius(12)
                        }
                        Button { withAnimation { isIncome = false; selectedCategory = nil } } label: {
                            Text("Expense").font(.system(size: 14, weight: .semibold))
                                .foregroundColor(!isIncome ? .black : .white.opacity(0.5))
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(!isIncome ? Color(red: 1.0, green: 0.38, blue: 0.38) : Color.clear).cornerRadius(12)
                        }
                    }.padding(4).background(Color.white.opacity(0.07)).cornerRadius(14)

                    // Amount
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amount").font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.5))
                        HStack {
                            Text("$").font(.system(size: 18, weight: .semibold)).foregroundColor(.white.opacity(0.5))
                            TextField("0.00", text: $amountText).keyboardType(.decimalPad)
                                .font(.system(size: 22, weight: .bold, design: .rounded)).foregroundColor(.white)
                        }.padding(16).background(Color.white.opacity(0.08)).cornerRadius(14)
                    }

                    // Category
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Category").font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.5))
                            Spacer()
                            if let cat = selectedCategory {
                                HStack(spacing: 5) {
                                    Image(systemName: cat.icon).font(.system(size: 10)).foregroundColor(cat.color)
                                    Text(cat.name).font(.system(size: 11, weight: .semibold)).foregroundColor(cat.color)
                                }.padding(.horizontal, 10).padding(.vertical, 4).background(cat.color.opacity(0.12)).cornerRadius(8)
                            }
                        }
                        CategoryGridPicker(isIncome: isIncome, selected: $selectedCategory)
                            .padding(14).background(Color.white.opacity(0.06)).cornerRadius(16)
                        if selectedCategory?.name == "Other" {
                            TextField("Describe it...", text: $customCategory)
                                .padding(14).background(Color.white.opacity(0.08)).cornerRadius(12)
                                .foregroundColor(.white).font(.system(size: 14))
                        }
                    }

                    // Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date").font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.5))
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact).colorScheme(.dark)
                            .padding(.horizontal, 16).padding(.vertical, 10)
                            .background(Color.white.opacity(0.08)).cornerRadius(14).labelsHidden()
                    }

                    let canSave = !amountText.isEmpty && selectedCategory != nil &&
                        (selectedCategory?.name != "Other" || !customCategory.trimmingCharacters(in: .whitespaces).isEmpty)

                    // Save
                    Button {
                        guard let amount = Double(amountText), let cat = selectedCategory else { return }
                        let catName = cat.name == "Other" ? customCategory.trimmingCharacters(in: .whitespaces) : cat.name
                        let updated = Transaction(id: transaction.id, amount: amount, date: selectedDate,
                                                  type: isIncome ? "Income" : "Expense", category: catName)
                        onSave(updated)
                        dismiss()
                    } label: {
                        Text("Save Changes").font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding(.vertical, 16)
                            .background(Color(red: 0.2, green: 0.85, blue: 0.55)).cornerRadius(16)
                    }.disabled(!canSave).opacity(canSave ? 1.0 : 0.4)

                    // Delete
                    Button {
                        onDelete()
                        dismiss()
                    } label: {
                        Text("Delete Transaction").font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 1.0, green: 0.38, blue: 0.38))
                            .frame(maxWidth: .infinity).padding(.vertical, 16)
                            .background(Color(red: 1.0, green: 0.38, blue: 0.38).opacity(0.12)).cornerRadius(16)
                    }
                }
                .padding(.horizontal, 18).padding(.bottom, 30)
            }
        }
    }
}

// MARK: - Content View

struct ContentView<RepositoryType: StudentRepository & ObservableObject>: View {

    @ObservedObject var repository: RepositoryType
    private let service: FinancialService
    let currentStudentId: String
    var onSignOut: () -> Void

    @State private var amountText = ""
    @State private var categoryText = ""
    @State private var selectedCategory: TransactionCategory? = nil
    @State private var recurrenceSelection: Recurrence = .none
    @State private var whatIfAmount = "120"
    @State private var selectedCalendarDate = Date()
    @State private var isIncome = true
    @State private var selectedDate = Date()
    @State private var selectedTab = 0
    @State private var editingTransaction: Transaction? = nil

    init(repository: RepositoryType, currentStudentId: String, onSignOut: @escaping () -> Void) {
        self.repository = repository
        self.currentStudentId = currentStudentId
        self.onSignOut = onSignOut
        self.service = FinancialService(repository: repository)
    }

    // Always read fresh from repository - repository.objectWillChange drives redraws
    private var student: Student? { repository.findStudent(byId: currentStudentId) }

    var body: some View {
        TabView(selection: $selectedTab) {
            dashboardView.tabItem { Label("Home", systemImage: "house.fill") }.tag(0)
            calendarView.tabItem { Label("Calendar", systemImage: "calendar") }.tag(1)
            addTransactionView.tabItem { Label("Add", systemImage: "plus.circle.fill") }.tag(2)
            trendsView.tabItem { Label("Insights", systemImage: "chart.bar.fill") }.tag(3)
        }
        .accentColor(Color(red: 0.2, green: 0.85, blue: 0.55))

        .sheet(item: $editingTransaction) { tx in
            EditTransactionSheet(
                transaction: tx,
                onSave: { updated in
                    guard let s = student,
                          let idx = s.transactions.firstIndex(where: { $0.id == updated.id })
                    else { return }
                    s.transactions[idx] = updated
                    repository.saveStudent(s)
                },
                onDelete: {
                    guard let s = student else { return }
                    s.transactions.removeAll { $0.id == tx.id }
                    repository.saveStudent(s)
                }
            )
        }
    }

    // MARK: - Shared background

    private var bgGradient: some View {
        LinearGradient(colors: [Color(red: 0.06, green: 0.07, blue: 0.12),
                                Color(red: 0.08, green: 0.10, blue: 0.18)],
                       startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
    }

    // MARK: - Dashboard

    private var dashboardView: some View {
        NavigationView {
            ZStack {
                bgGradient
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("UniWallet")
                                    .font(.system(size: 30, weight: .bold, design: .rounded)).foregroundColor(.white)
                                Text(greetingText()).font(.system(size: 13)).foregroundColor(.white.opacity(0.5))
                            }
                            Spacer()
                            HStack(spacing: 10) {
                                Button { selectedTab = 2 } label: {
                                    Image(systemName: "plus").font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.black).frame(width: 36, height: 36)
                                        .background(Color(red: 0.2, green: 0.85, blue: 0.55)).clipShape(Circle())
                                }
                                Button { onSignOut() } label: {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.6)).frame(width: 36, height: 36)
                                        .background(Color.white.opacity(0.1)).clipShape(Circle())
                                }
                            }
                        }.padding(.top, 8)

                        if let student = student {
                            balanceHeroCard(student: student)
                            summaryCards(student: student)
                            if let runway = service.semesterRunway(for: currentStudentId) { runwayCard(runway: runway) }
                            let payments = service.upcomingPayments(for: currentStudentId)
                            if !payments.isEmpty { upcomingPaymentsCard(payments: payments) }
                            safetyWarningsCard(warnings: service.safetyWarnings(for: currentStudentId))
                            whatIfCard()
                            recentTransactionsCard(student: student)
                            tipsCard()
                        } else {
                            Text("No student data found").foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 18).padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Balance Hero Card

    private func balanceHeroCard(student: Student) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Balance")
                .font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase).kerning(0.8)
            Text("$\(student.balance(), specifier: "%.0f")")
                .font(.system(size: 44, weight: .bold, design: .rounded)).foregroundColor(.white)
            Divider().background(Color.white.opacity(0.12))
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Income").font(.system(size: 11, weight: .medium)).foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.8))
                    Text("+$\(student.totalIncome(), specifier: "%.0f")").font(.system(size: 17, weight: .semibold, design: .rounded)).foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Expenses").font(.system(size: 11, weight: .medium)).foregroundColor(Color(red: 1.0, green: 0.38, blue: 0.38).opacity(0.8))
                    Text("-$\(student.totalExpenses(), specifier: "%.0f")").font(.system(size: 17, weight: .semibold, design: .rounded)).foregroundColor(Color(red: 1.0, green: 0.38, blue: 0.38))
                }
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 22).fill(LinearGradient(colors: [Color(red: 0.10, green: 0.38, blue: 0.28), Color(red: 0.07, green: 0.25, blue: 0.20)], startPoint: .topLeading, endPoint: .bottomTrailing)))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.25), lineWidth: 1))
    }

    private func summaryCards(student: Student) -> some View {
        HStack(spacing: 10) {
            miniStatCard(title: "Month Income",   value: "$\(Int(student.totalIncomeThisMonth()))",   icon: "arrow.down.circle.fill", color: Color(red: 0.2, green: 0.85, blue: 0.55))
            miniStatCard(title: "Month Expenses", value: "$\(Int(student.totalExpensesThisMonth()))", icon: "arrow.up.circle.fill",   color: Color(red: 1.0, green: 0.38, blue: 0.38))
        }
    }

    private func miniStatCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).font(.system(size: 18)).foregroundColor(color)
            Text(value).font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white)
            Text(title).font(.system(size: 11)).foregroundColor(.white.opacity(0.45)).lineLimit(2)
        }
        .padding(14).frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.07)).cornerRadius(16)
    }

    private func runwayCard(runway: SemesterRunwaySummary) -> some View {
        let pct = min(1.0, max(0, runway.safeWeeklySpending / 300.0))
        return VStack(alignment: .leading, spacing: 14) {
            Label("Semester Runway", systemImage: "calendar.badge.clock")
                .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
            HStack(alignment: .firstTextBaseline) {
                Text("$\(runway.remainingBalance, specifier: "%.0f")").font(.system(size: 26, weight: .bold, design: .rounded)).foregroundColor(.white)
                Text("remaining").font(.system(size: 12)).foregroundColor(.white.opacity(0.45))
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.1)).frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(colors: [Color(red: 0.2, green: 0.85, blue: 0.55), Color(red: 0.1, green: 0.65, blue: 0.45)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * pct, height: 6)
                }
            }.frame(height: 6)
            HStack {
                Label("$\(runway.safeWeeklySpending, specifier: "%.0f")/week safe", systemImage: "checkmark.shield.fill")
                    .font(.system(size: 12)).foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55))
                Spacer()
                Text("\(runway.weeksRemaining) weeks left").font(.system(size: 12)).foregroundColor(.white.opacity(0.45))
            }
        }
        .padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)
    }

    private func upcomingPaymentsCard(payments: [UpcomingPayment]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Upcoming Payments", systemImage: "calendar.badge.exclamationmark")
                .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
            ForEach(payments.prefix(4)) { payment in
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(payment.isIncoming ? Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.15) : Color(red: 1.0, green: 0.38, blue: 0.38).opacity(0.15)).frame(width: 34, height: 34)
                        Image(systemName: payment.isIncoming ? "arrow.down" : "arrow.up")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(payment.isIncoming ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(payment.title).font(.system(size: 13, weight: .medium)).foregroundColor(.white)
                        Text(formattedDate(payment.dueDate)).font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                    }
                    Spacer()
                    Text("\(payment.isIncoming ? "+" : "-")$\(payment.amount, specifier: "%.0f")")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(payment.isIncoming ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                }
            }
        }
        .padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)
    }

    private func safetyWarningsCard(warnings: [FinancialAlert]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Alerts", systemImage: "bell.badge.fill")
                .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
            ForEach(warnings) { alert in
                HStack(spacing: 10) {
                    Circle().fill(alertColor(for: alert.severity).opacity(0.25)).frame(width: 8, height: 8)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(alert.title).font(.system(size: 12, weight: .semibold)).foregroundColor(alertColor(for: alert.severity))
                        Text(alert.message).font(.system(size: 11)).foregroundColor(.white.opacity(0.5))
                    }
                }
            }
        }
        .padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)
    }

    private func whatIfCard() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("What-If Simulator", systemImage: "questionmark.circle.fill")
                .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
            TextField("Amount", text: $whatIfAmount).keyboardType(.decimalPad)
                .font(.system(size: 14)).padding(.horizontal, 12).padding(.vertical, 10)
                .background(Color.white.opacity(0.08)).cornerRadius(10).foregroundColor(.white)
            if let amount = Double(whatIfAmount),
               let result = service.whatIfExpenseImpact(for: currentStudentId, extraExpense: amount) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("New weekly budget").font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                        Text("$\(result.newSafeWeeklySpending, specifier: "%.0f")/week").font(.system(size: 16, weight: .semibold, design: .rounded)).foregroundColor(.white)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("Runway reduced").font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                        Text("\(result.runwayDaysReduced) days").font(.system(size: 16, weight: .semibold, design: .rounded)).foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.2))
                    }
                }
                .padding(12).background(Color.white.opacity(0.05)).cornerRadius(12)
            }
        }
        .padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)
    }

    private func recentTransactionsCard(student: Student) -> some View {
        let sorted = student.transactions.filter { $0.date <= Date() }.sorted { $0.date > $1.date }
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Recent Transactions", systemImage: "list.bullet.rectangle")
                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                Spacer()
                Text("Tap to edit").font(.system(size: 10)).foregroundColor(.white.opacity(0.3))
            }
            if sorted.isEmpty {
                HStack { Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "tray").font(.system(size: 28)).foregroundColor(.white.opacity(0.2))
                        Text("No transactions yet").font(.system(size: 12)).foregroundColor(.white.opacity(0.3))
                    }.padding(.vertical, 20)
                    Spacer()
                }
            } else {
                ForEach(sorted.prefix(10), id: \.id) { t in
                    Button { editingTransaction = t } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(t.type == "Income" ? Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.12) : Color(red: 1.0, green: 0.38, blue: 0.38).opacity(0.12))
                                    .frame(width: 36, height: 36)
                                Image(systemName: t.type == "Income" ? "plus" : "minus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(t.type == "Income" ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(t.category).font(.system(size: 13, weight: .medium)).foregroundColor(.white)
                                Text(formattedDate(t.date)).font(.system(size: 10)).foregroundColor(.white.opacity(0.35))
                            }
                            Spacer()
                            Text(t.type == "Income" ? "+$\(t.amount, specifier: "%.0f")" : "-$\(t.amount, specifier: "%.0f")")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(t.type == "Income" ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                            Image(systemName: "pencil").font(.system(size: 11)).foregroundColor(.white.opacity(0.25))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)
    }

    private func tipsCard() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("York Tips", systemImage: "lightbulb.fill")
                .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
            ForEach(service.yorkSpecificTips()) { tip in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "sparkle").font(.system(size: 10)).foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.2)).padding(.top, 2)
                    Text(tip.message).font(.system(size: 12)).foregroundColor(.white.opacity(0.55))
                }
            }
        }
        .padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)
    }

    // MARK: - Calendar View

    private var calendarView: some View {
        NavigationView {
            ZStack {
                bgGradient
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Calendar").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundColor(.white).padding(.top, 8)
                        if let student = student {
                            CalendarMonthView(selectedDate: $selectedCalendarDate, transactions: student.transactions)
                            let dayTx = transactionsForDate(selectedCalendarDate, student: student)
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    Text(formattedDate(selectedCalendarDate)).font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                                    Spacer()
                                    Text(dayTx.isEmpty ? "No transactions" : "\(dayTx.count) transaction\(dayTx.count > 1 ? "s" : "")")
                                        .font(.system(size: 11)).foregroundColor(.white.opacity(0.35))
                                }
                                if dayTx.isEmpty {
                                    HStack { Spacer()
                                        VStack(spacing: 8) {
                                            Image(systemName: "calendar.badge.plus").font(.system(size: 28)).foregroundColor(.white.opacity(0.2))
                                            Text("Tap + to add a transaction").font(.system(size: 12)).foregroundColor(.white.opacity(0.3))
                                        }.padding(.vertical, 20); Spacer()
                                    }
                                } else {
                                    ForEach(dayTx, id: \.id) { t in
                                        Button { editingTransaction = t } label: {
                                            HStack(spacing: 12) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(t.type == "Income" ? Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.12) : Color(red: 1.0, green: 0.38, blue: 0.38).opacity(0.12))
                                                        .frame(width: 36, height: 36)
                                                    Image(systemName: t.type == "Income" ? "plus" : "minus")
                                                        .font(.system(size: 12, weight: .bold))
                                                        .foregroundColor(t.type == "Income" ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                                                }
                                                Text(t.category).font(.system(size: 13, weight: .medium)).foregroundColor(.white)
                                                Spacer()
                                                Text(t.type == "Income" ? "+$\(t.amount, specifier: "%.0f")" : "-$\(t.amount, specifier: "%.0f")")
                                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                    .foregroundColor(t.type == "Income" ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                                                Image(systemName: "pencil").font(.system(size: 11)).foregroundColor(.white.opacity(0.25))
                                            }
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                    Divider().background(Color.white.opacity(0.1))
                                    let di = dayTx.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }
                                    let de = dayTx.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
                                    HStack {
                                        Text("Net this day").font(.system(size: 12)).foregroundColor(.white.opacity(0.4))
                                        Spacer()
                                        Text("\(di - de >= 0 ? "+" : "")$\(di - de, specifier: "%.0f")")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(di - de >= 0 ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                                    }
                                }
                            }
                            .padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)
                            monthlySummaryCard(student: student)
                        }
                    }
                    .padding(.horizontal, 18).padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func monthlySummaryCard(student: Student) -> some View {
        let cal = Calendar.current
        let month = cal.component(.month, from: selectedCalendarDate)
        let year  = cal.component(.year,  from: selectedCalendarDate)
        guard let start = cal.date(from: DateComponents(year: year, month: month, day: 1)),
              let end   = cal.date(byAdding: DateComponents(month: 1, day: -1), to: start)
        else { return AnyView(EmptyView()) }
        let income = student.incomeBetween(start: start, end: end)
        let expenses = student.expensesBetween(start: start, end: end)
        let net = income - expenses
        return AnyView(
            VStack(alignment: .leading, spacing: 14) {
                Text("Month Summary").font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Income").font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                        Text("+$\(income, specifier: "%.0f")").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55))
                    }
                    Spacer()
                    VStack(alignment: .center, spacing: 4) {
                        Text("Net").font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                        Text("\(net >= 0 ? "+" : "")$\(net, specifier: "%.0f")").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(net >= 0 ? .white : Color(red: 1.0, green: 0.38, blue: 0.38))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Expenses").font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                        Text("-$\(expenses, specifier: "%.0f")").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(Color(red: 1.0, green: 0.38, blue: 0.38))
                    }
                }
            }
            .padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)
        )
    }

    // MARK: - Add Transaction

    private var addTransactionView: some View {
        NavigationView {
            ZStack {
                bgGradient
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        Text("Add Transaction").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundColor(.white).padding(.top, 8)

                        HStack(spacing: 0) {
                            Button { withAnimation(.spring(response: 0.3)) { isIncome = true; selectedCategory = nil } } label: {
                                Text("Income").font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(isIncome ? .black : .white.opacity(0.5))
                                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                                    .background(isIncome ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color.clear).cornerRadius(12)
                            }
                            Button { withAnimation(.spring(response: 0.3)) { isIncome = false; selectedCategory = nil } } label: {
                                Text("Expense").font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(!isIncome ? .black : .white.opacity(0.5))
                                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                                    .background(!isIncome ? Color(red: 1.0, green: 0.38, blue: 0.38) : Color.clear).cornerRadius(12)
                            }
                        }.padding(4).background(Color.white.opacity(0.07)).cornerRadius(14)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amount").font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.5))
                            HStack {
                                Text("$").font(.system(size: 18, weight: .semibold)).foregroundColor(.white.opacity(0.5))
                                TextField("0.00", text: $amountText).keyboardType(.decimalPad)
                                    .font(.system(size: 22, weight: .bold, design: .rounded)).foregroundColor(.white)
                            }.padding(16).background(Color.white.opacity(0.08)).cornerRadius(14)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Category").font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.5))
                                Spacer()
                                if let cat = selectedCategory {
                                    HStack(spacing: 5) {
                                        Image(systemName: cat.icon).font(.system(size: 10)).foregroundColor(cat.color)
                                        Text(cat.name).font(.system(size: 11, weight: .semibold)).foregroundColor(cat.color)
                                    }.padding(.horizontal, 10).padding(.vertical, 4).background(cat.color.opacity(0.12)).cornerRadius(8)
                                }
                            }
                            CategoryGridPicker(isIncome: isIncome, selected: $selectedCategory)
                                .padding(14).background(Color.white.opacity(0.06)).cornerRadius(16)
                            if selectedCategory?.name == "Other" {
                                TextField("Describe it...", text: $categoryText)
                                    .padding(14).background(Color.white.opacity(0.08)).cornerRadius(12)
                                    .foregroundColor(.white).font(.system(size: 14))
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date").font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.5))
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.compact).colorScheme(.dark)
                                .padding(.horizontal, 16).padding(.vertical, 10)
                                .background(Color.white.opacity(0.08)).cornerRadius(14).labelsHidden()
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Repeat").font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.5))
                            Picker("Repeat", selection: $recurrenceSelection) {
                                ForEach(Recurrence.allCases) { r in Text(r.rawValue.capitalized).tag(r) }
                            }.pickerStyle(.segmented).colorScheme(.dark)
                        }

                        let canSubmit = !amountText.isEmpty && selectedCategory != nil &&
                            (selectedCategory?.name != "Other" || !categoryText.trimmingCharacters(in: .whitespaces).isEmpty)

                        Button { submitTransaction() } label: {
                            HStack {
                                Image(systemName: isIncome ? "plus.circle.fill" : "minus.circle.fill")
                                Text("Add \(isIncome ? "Income" : "Expense")").fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 16)
                            .background(isIncome ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                            .foregroundColor(.black).cornerRadius(16).font(.system(size: 16))
                        }.disabled(!canSubmit).opacity(canSubmit ? 1.0 : 0.4)
                    }
                    .padding(.horizontal, 18).padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Trends

    private var trendsView: some View {
        NavigationView {
            ZStack {
                bgGradient
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Insights").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundColor(.white).padding(.top, 8)
                        if let trend = service.spendingTrend(for: currentStudentId) {
                            HStack(spacing: 10) {
                                insightCard(title: "Month Income",   value: "$\(Int(trend.monthIncome))",   icon: "arrow.down.circle.fill", accent: Color(red: 0.2, green: 0.85, blue: 0.55))
                                insightCard(title: "Month Expenses", value: "$\(Int(trend.monthExpenses))", icon: "arrow.up.circle.fill",   accent: Color(red: 1.0, green: 0.38, blue: 0.38))
                            }
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Top Spending Category", systemImage: "chart.bar.xaxis")
                                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                                HStack {
                                    Text(trend.topCategory).font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                                    Spacer()
                                    Text("$\(trend.topCategoryAmount, specifier: "%.0f")").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(Color(red: 1.0, green: 0.38, blue: 0.38))
                                }
                            }.padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)

                            VStack(alignment: .leading, spacing: 14) {
                                Label("Expense Mix", systemImage: "chart.pie.fill")
                                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                                expenseMixBar(fixed: trend.fixedExpensePercentage, variable: trend.variableExpensePercentage)
                                HStack {
                                    HStack(spacing: 6) { Circle().fill(Color(red: 0.2, green: 0.85, blue: 0.55)).frame(width: 8, height: 8); Text("Fixed \(Int(trend.fixedExpensePercentage))%").font(.system(size: 12)).foregroundColor(.white.opacity(0.6)) }
                                    Spacer()
                                    HStack(spacing: 6) { Circle().fill(Color(red: 1.0, green: 0.38, blue: 0.38)).frame(width: 8, height: 8); Text("Variable \(Int(trend.variableExpensePercentage))%").font(.system(size: 12)).foregroundColor(.white.opacity(0.6)) }
                                }
                            }.padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)

                            if let commuter = service.commuterCosts(for: currentStudentId) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Label("Commuter Costs", systemImage: "tram.fill")
                                        .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                                    HStack {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("TTC").font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                                            Text("$\(commuter.weeklyTTC, specifier: "%.0f")/week").font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing, spacing: 3) {
                                            Text("GO Transit").font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                                            Text("$\(commuter.weeklyGOTransit, specifier: "%.0f")/week").font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                                        }
                                    }
                                }.padding(18).background(Color.white.opacity(0.07)).cornerRadius(20)
                            }
                        } else {
                            Text("No insight data available.").foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 18).padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func insightCard(title: String, value: String, icon: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).font(.system(size: 16)).foregroundColor(accent)
            Text(value).font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white)
            Text(title).font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
        }.padding(14).frame(maxWidth: .infinity, alignment: .leading).background(Color.white.opacity(0.07)).cornerRadius(16)
    }

    private func expenseMixBar(fixed: Double, variable: Double) -> some View {
        GeometryReader { geo in
            let total = max(1, fixed + variable)
            HStack(spacing: 2) {
                RoundedRectangle(cornerRadius: 4).fill(Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.7))
                    .frame(width: max(4, geo.size.width * (fixed / total)), height: 8)
                RoundedRectangle(cornerRadius: 4).fill(Color(red: 1.0, green: 0.38, blue: 0.38).opacity(0.7))
                    .frame(maxWidth: .infinity, minHeight: 8, maxHeight: 8)
            }
        }.frame(height: 8)
    }

    // MARK: - Helpers

    private func transactionsForDate(_ date: Date, student: Student) -> [Transaction] {
        let cal = Calendar.current
        return student.transactions.filter { cal.isDate($0.date, inSameDayAs: date) }.sorted { $0.date > $1.date }
    }

    private func submitTransaction() {
        guard let amount = Double(amountText), let cat = selectedCategory else { return }
        let catName = cat.name == "Other" ? categoryText.trimmingCharacters(in: .whitespaces) : cat.name
        if isIncome {
            service.addIncome(studentId: currentStudentId, amount: amount, category: catName, date: selectedDate, recurrence: recurrenceSelection)
        } else {
            service.addExpense(studentId: currentStudentId, amount: amount, category: catName, date: selectedDate, recurrence: recurrenceSelection)
        }
        amountText = ""; categoryText = ""; selectedCategory = nil; recurrenceSelection = .none
    }

    private func alertColor(for severity: AlertSeverity) -> Color {
        switch severity {
        case .info:     return Color(red: 0.4, green: 0.7, blue: 1.0)
        case .warning:  return Color(red: 1.0, green: 0.75, blue: 0.2)
        case .critical: return Color(red: 1.0, green: 0.38, blue: 0.38)
        }
    }

    private func greetingText() -> String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 12 { return "Good morning" }
        if h < 17 { return "Good afternoon" }
        return "Good evening"
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter(); f.dateStyle = .medium; return f.string(from: date)
    }
}
