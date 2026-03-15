//
//  StudentRepositoryReal.swift
//  PersonalFinancialPlanner
//
//  Created by Mehrshad Zarastounia on 2026-03-05.
//
import Foundation
import Combine

final class StudentRepositoryReal: ObservableObject, StudentRepository {
    
    @Published private var students: [Student] = []
    private let fileName = "students_db.json"
    
    init() {
        loadStudents()
        
        if students.isEmpty {
            seedDefaultData()
            persistStudents()
        }
    }
    
    func getAllStudents() -> [Student] {
        students
    }
    
    func findStudent(byId id: String) -> Student? {
        students.first { $0.id == id }
    }
    
    func saveStudent(_ student: Student) {
        if let index = students.firstIndex(where: { $0.id == student.id }) {
            students[index] = student
        } else {
            students.append(student)
        }
        
        persistStudents()
        objectWillChange.send()
    }
    
    private func seedDefaultData() {
        let calendar = Calendar.current
        let now = Date()
        
        let semesterStart = calendar.date(byAdding: .day, value: -14, to: now) ?? now
        let semesterEnd = calendar.date(byAdding: .day, value: 90, to: now) ?? now
        let tuitionDue = calendar.date(byAdding: .day, value: 10, to: now) ?? now
        let osapDate = calendar.date(byAdding: .day, value: 18, to: now) ?? now
        let nextPay = calendar.date(byAdding: .day, value: 7, to: now) ?? now
        let rentDate = calendar.date(byAdding: .day, value: 15, to: now) ?? now
        
        let plan = SemesterPlan(
            semesterName: "Fall Semester",
            startDate: semesterStart,
            endDate: semesterEnd,
            tuitionDueDate: tuitionDue,
            tuitionAmount: 4200,
            osapExpectedDate: osapDate,
            osapAmount: 2800,
            monthlyRent: 1500,
            mealPlanBalance: 450,
            weeklyTTC: 37,
            weeklyGOTransit: 28,
            nextPaycheckDate: nextPay,
            nextPaycheckAmount: 1560,
            commuteType: .commuter,
            upcomingPayments: [
                UpcomingPayment(title: "Tuition due", amount: 4200, dueDate: tuitionDue, isIncoming: false),
                UpcomingPayment(title: "OSAP expected deposit", amount: 2800, dueDate: osapDate, isIncoming: true),
                UpcomingPayment(title: "Rent", amount: 1500, dueDate: rentDate, isIncoming: false)
            ]
        )
        
        let alice = Student(
            id: "S001",
            name: "Alice",
            transactions: [
                Transaction(id: UUID().uuidString, amount: 3200, date: calendar.date(byAdding: .day, value: -12, to: now) ?? now, type: "Income", category: "OSAP"),
                Transaction(id: UUID().uuidString, amount: 900, date: calendar.date(byAdding: .day, value: -9, to: now) ?? now, type: "Income", category: "Part-Time Job"),
                Transaction(id: UUID().uuidString, amount: 1500, date: calendar.date(byAdding: .day, value: -8, to: now) ?? now, type: "Expense", category: "Rent"),
                Transaction(id: UUID().uuidString, amount: 180, date: calendar.date(byAdding: .day, value: -6, to: now) ?? now, type: "Expense", category: "Groceries"),
                Transaction(id: UUID().uuidString, amount: 65, date: calendar.date(byAdding: .day, value: -5, to: now) ?? now, type: "Expense", category: "TTC"),
                Transaction(id: UUID().uuidString, amount: 120, date: calendar.date(byAdding: .day, value: -2, to: now) ?? now, type: "Expense", category: "Food")
            ],
            semesterPlan: plan
        )
        
        let bob = Student(id: "S002", name: "Bob", transactions: [], semesterPlan: nil)
        students = [alice, bob]
    }
    
    private func loadStudents() {
        let url = databaseURL()
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            students = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            students = try JSONDecoder().decode([Student].self, from: data)
        } catch {
            print("Failed to load student database: \(error.localizedDescription)")
            students = []
        }
    }
    
    private func persistStudents() {
        do {
            let data = try JSONEncoder().encode(students)
            try data.write(to: databaseURL(), options: .atomic)
        } catch {
            print("Failed to save student database: \(error.localizedDescription)")
        }
    }
    
    private func databaseURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName)
    }
}
