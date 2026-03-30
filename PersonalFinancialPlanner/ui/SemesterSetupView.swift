import SwiftUI

struct SemesterSetupView: View {
    let student: Student
    var onComplete: (SemesterPlan) -> Void

    // Semester dates
    @State private var semesterName = ""
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .month, value: 4, to: Date()) ?? Date()

    // Financial info
    @State private var tuitionAmount = ""
    @State private var tuitionDueDate = Date()
    @State private var osapAmount = ""
    @State private var osapDate = Date()
    @State private var monthlyRent = ""
    @State private var mealPlanBalance = ""

    // Commute
    @State private var commuteType: CommuteType = .commuter
    @State private var weeklyTTC = ""
    @State private var weeklyGO = ""

    // Paycheck
    @State private var nextPaycheckAmount = ""
    @State private var nextPaycheckDate = Date()

    // Upcoming payments
    @State private var upcomingPayments: [UpcomingPayment] = []
    @State private var showAddPayment = false
    @State private var newPayTitle = ""
    @State private var newPayAmount = ""
    @State private var newPayDate = Date()
    @State private var newPayIsIncoming = false

    @State private var currentStep = 0
    private let totalSteps = 4

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.06, green: 0.07, blue: 0.12),
                         Color(red: 0.08, green: 0.10, blue: 0.18)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                VStack(spacing: 12) {
                    HStack {
                        Text("Semester Setup")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Text("Step \(currentStep + 1) of \(totalSteps)")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.1)).frame(height: 4)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(red: 0.2, green: 0.85, blue: 0.55))
                                .frame(width: geo.size.width * (Double(currentStep + 1) / Double(totalSteps)), height: 4)
                                .animation(.spring(response: 0.4), value: currentStep)
                        }
                    }.frame(height: 4)
                }
                .padding(.horizontal, 22)
                .padding(.top, 20)
                .padding(.bottom, 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Step content
                        switch currentStep {
                        case 0: stepSemesterDates
                        case 1: stepFinancials
                        case 2: stepCommute
                        case 3: stepUpcomingPayments
                        default: EmptyView()
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 8)
                    .padding(.bottom, 30)
                }

                // Navigation buttons
                HStack(spacing: 12) {
                    if currentStep > 0 {
                        Button {
                            withAnimation { currentStep -= 1 }
                        } label: {
                            Text("Back")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(14)
                        }
                    }

                    Button {
                        if currentStep < totalSteps - 1 {
                            withAnimation { currentStep += 1 }
                        } else {
                            savePlan()
                        }
                    } label: {
                        Text(currentStep == totalSteps - 1 ? "Finish Setup" : "Continue")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color(red: 0.2, green: 0.85, blue: 0.55))
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showAddPayment) {
            addPaymentSheet
        }
    }

    // MARK: - Step 1: Semester Dates

    private var stepSemesterDates: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome, \(student.name)!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("Let's set up your semester so UniWallet can track your finances accurately.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
                    .lineSpacing(4)
            }

            fieldLabel("Semester Name")
            TextField("e.g. Winter 2026", text: $semesterName)
                .styledInput()

            fieldLabel("Semester Start Date")
            DatePicker("", selection: $startDate, displayedComponents: .date)
                .datePickerStyle(.compact).colorScheme(.dark)
                .styledDatePicker()

            fieldLabel("Semester End Date")
            DatePicker("", selection: $endDate, displayedComponents: .date)
                .datePickerStyle(.compact).colorScheme(.dark)
                .styledDatePicker()
        }
    }

    // MARK: - Step 2: Financials

    private var stepFinancials: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Financial Info")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text("Leave anything blank if it doesn't apply to you.")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.4))

            Group {
                fieldLabel("Tuition Amount ($)")
                TextField("e.g. 4200", text: $tuitionAmount)
                    .keyboardType(.decimalPad).styledInput()

                fieldLabel("Tuition Due Date")
                DatePicker("", selection: $tuitionDueDate, displayedComponents: .date)
                    .datePickerStyle(.compact).colorScheme(.dark).styledDatePicker()

                fieldLabel("OSAP / Financial Aid Amount ($)")
                TextField("e.g. 2800", text: $osapAmount)
                    .keyboardType(.decimalPad).styledInput()

                fieldLabel("OSAP Expected Date")
                DatePicker("", selection: $osapDate, displayedComponents: .date)
                    .datePickerStyle(.compact).colorScheme(.dark).styledDatePicker()

                fieldLabel("Monthly Rent ($)")
                TextField("e.g. 1500", text: $monthlyRent)
                    .keyboardType(.decimalPad).styledInput()

                fieldLabel("Meal Plan Balance ($)")
                TextField("e.g. 450", text: $mealPlanBalance)
                    .keyboardType(.decimalPad).styledInput()
            }

            Group {
                fieldLabel("Next Paycheck Amount ($)")
                TextField("e.g. 1200", text: $nextPaycheckAmount)
                    .keyboardType(.decimalPad).styledInput()

                fieldLabel("Next Paycheck Date")
                DatePicker("", selection: $nextPaycheckDate, displayedComponents: .date)
                    .datePickerStyle(.compact).colorScheme(.dark).styledDatePicker()
            }
        }
    }

    // MARK: - Step 3: Commute

    private var stepCommute: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Commute & Transport")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            fieldLabel("I live...")
            HStack(spacing: 10) {
                commuteButton(title: "Off Campus", subtitle: "Commuter", type: .commuter)
                commuteButton(title: "On Campus", subtitle: "Residence", type: .residence)
            }

            fieldLabel("Weekly TTC Cost ($)")
            TextField("e.g. 37", text: $weeklyTTC)
                .keyboardType(.decimalPad).styledInput()

            fieldLabel("Weekly GO Transit Cost ($)")
            TextField("e.g. 28", text: $weeklyGO)
                .keyboardType(.decimalPad).styledInput()
        }
    }

    private func commuteButton(title: String, subtitle: String, type: CommuteType) -> some View {
        let isSelected = commuteType == type
        return Button { commuteType = type } label: {
            VStack(spacing: 6) {
                Image(systemName: type == .commuter ? "tram.fill" : "building.2.fill")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .black : .white.opacity(0.5))
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isSelected ? .black : .white.opacity(0.7))
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .black.opacity(0.6) : .white.opacity(0.35))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(isSelected ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color.white.opacity(0.07))
            .cornerRadius(14)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Step 4: Upcoming Payments

    private var stepUpcomingPayments: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Upcoming Payments")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("Add any known upcoming bills or income (optional).")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.4))
            }

            if upcomingPayments.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.15))
                        Text("No payments added yet")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
                    }.padding(.vertical, 24)
                    Spacer()
                }
                .background(Color.white.opacity(0.04))
                .cornerRadius(16)
            } else {
                VStack(spacing: 10) {
                    ForEach(upcomingPayments) { payment in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(payment.isIncoming ? Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.15) : Color(red: 1.0, green: 0.38, blue: 0.38).opacity(0.15))
                                    .frame(width: 32, height: 32)
                                Image(systemName: payment.isIncoming ? "arrow.down" : "arrow.up")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(payment.isIncoming ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(payment.title).font(.system(size: 13, weight: .medium)).foregroundColor(.white)
                                Text(formattedDate(payment.dueDate)).font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                            }
                            Spacer()
                            Text("\(payment.isIncoming ? "+" : "-")$\(payment.amount, specifier: "%.0f")")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(payment.isIncoming ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color(red: 1.0, green: 0.38, blue: 0.38))
                            Button {
                                upcomingPayments.removeAll { $0.id == payment.id }
                            } label: {
                                Image(systemName: "trash").font(.system(size: 12)).foregroundColor(.white.opacity(0.3))
                            }
                        }
                    }
                }
                .padding(14)
                .background(Color.white.opacity(0.06))
                .cornerRadius(16)
            }

            Button { showAddPayment = true } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Payment / Income")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.1))
                .cornerRadius(14)
            }
        }
    }

    // MARK: - Add Payment Sheet

    private var addPaymentSheet: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.06, green: 0.07, blue: 0.12), Color(red: 0.08, green: 0.10, blue: 0.18)],
                           startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Add Payment").font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white)
                    Spacer()
                    Button { showAddPayment = false } label: {
                        Image(systemName: "xmark").font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.6)).frame(width: 30, height: 30)
                            .background(Color.white.opacity(0.1)).clipShape(Circle())
                    }
                }.padding(.top, 8)

                // Type toggle
                HStack(spacing: 0) {
                    Button { newPayIsIncoming = false } label: {
                        Text("Bill / Expense")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(!newPayIsIncoming ? .black : .white.opacity(0.5))
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(!newPayIsIncoming ? Color(red: 1.0, green: 0.38, blue: 0.38) : Color.clear).cornerRadius(10)
                    }
                    Button { newPayIsIncoming = true } label: {
                        Text("Income")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(newPayIsIncoming ? .black : .white.opacity(0.5))
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(newPayIsIncoming ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color.clear).cornerRadius(10)
                    }
                }.padding(4).background(Color.white.opacity(0.07)).cornerRadius(12)

                fieldLabel("Title")
                TextField("e.g. Tuition, OSAP", text: $newPayTitle).styledInput()

                fieldLabel("Amount ($)")
                TextField("e.g. 4200", text: $newPayAmount).keyboardType(.decimalPad).styledInput()

                fieldLabel("Due Date")
                DatePicker("", selection: $newPayDate, displayedComponents: .date)
                    .datePickerStyle(.compact).colorScheme(.dark).styledDatePicker()

                Spacer()

                Button {
                    guard let amount = Double(newPayAmount), !newPayTitle.isEmpty else { return }
                    upcomingPayments.append(UpcomingPayment(title: newPayTitle, amount: amount, dueDate: newPayDate, isIncoming: newPayIsIncoming))
                    newPayTitle = ""; newPayAmount = ""; newPayDate = Date(); newPayIsIncoming = false
                    showAddPayment = false
                } label: {
                    Text("Add").font(.system(size: 15, weight: .semibold)).foregroundColor(.black)
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                        .background(Color(red: 0.2, green: 0.85, blue: 0.55)).cornerRadius(14)
                }
                .disabled(newPayTitle.isEmpty || newPayAmount.isEmpty)
                .opacity(newPayTitle.isEmpty || newPayAmount.isEmpty ? 0.4 : 1.0)
            }
            .padding(.horizontal, 22).padding(.bottom, 30)
        }
    }

    // MARK: - Save

    private func savePlan() {
        var allPayments = upcomingPayments

        // Auto-add tuition as upcoming expense
        if let amount = Double(tuitionAmount), amount > 0 {
            allPayments.append(UpcomingPayment(
                title: "Tuition", amount: amount,
                dueDate: tuitionDueDate, isIncoming: false
            ))
        }

        // Auto-add OSAP as upcoming income
        if let amount = Double(osapAmount), amount > 0 {
            allPayments.append(UpcomingPayment(
                title: "OSAP Deposit", amount: amount,
                dueDate: osapDate, isIncoming: true
            ))
        }

        // Auto-add rent as upcoming expense (first month)
        if let amount = Double(monthlyRent), amount > 0 {
            allPayments.append(UpcomingPayment(
                title: "Rent", amount: amount,
                dueDate: Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date(),
                isIncoming: false
            ))
        }

        // Auto-add next paycheck if set
        if let amount = Double(nextPaycheckAmount), amount > 0 {
            allPayments.append(UpcomingPayment(
                title: "Paycheck", amount: amount,
                dueDate: nextPaycheckDate, isIncoming: true
            ))
        }

        // Sort by date
        allPayments.sort { $0.dueDate < $1.dueDate }

        let plan = SemesterPlan(
            semesterName: semesterName.isEmpty ? "My Semester" : semesterName,
            startDate: startDate,
            endDate: endDate,
            tuitionDueDate: tuitionDueDate,
            tuitionAmount: Double(tuitionAmount) ?? 0,
            osapExpectedDate: osapDate,
            osapAmount: Double(osapAmount) ?? 0,
            monthlyRent: Double(monthlyRent) ?? 0,
            mealPlanBalance: Double(mealPlanBalance) ?? 0,
            weeklyTTC: Double(weeklyTTC) ?? 0,
            weeklyGOTransit: Double(weeklyGO) ?? 0,
            nextPaycheckDate: nextPaycheckDate,
            nextPaycheckAmount: Double(nextPaycheckAmount) ?? 0,
            commuteType: commuteType,
            upcomingPayments: allPayments
        )
        onComplete(plan)
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.5))
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter(); f.dateStyle = .medium; return f.string(from: date)
    }
}

// MARK: - View Modifiers

extension View {
    func styledInput() -> some View {
        self
            .padding(14)
            .background(Color.white.opacity(0.08))
            .cornerRadius(12)
            .foregroundColor(.white)
            .font(.system(size: 15))
    }

    func styledDatePicker() -> some View {
        self
            .labelsHidden()
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.08))
            .cornerRadius(12)
    }
}
