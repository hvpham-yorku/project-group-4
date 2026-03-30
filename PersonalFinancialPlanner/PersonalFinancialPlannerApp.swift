import SwiftUI

@main
struct PersonalFinancialPlannerApp: App {

    @StateObject private var repository = StudentRepositoryStub()
    @State private var loggedInStudentId: String? = nil
    @State private var setupDone = false

    private var loggedInStudent: Student? {
        guard let id = loggedInStudentId else { return nil }
        return repository.findStudent(byId: id)
    }

    var body: some Scene {
        WindowGroup {
            if let student = loggedInStudent {
                if !setupDone {
                    SemesterSetupView(student: student) { plan in
                        student.semesterPlan = plan
                        repository.saveStudent(student)  // triggers objectWillChange → ContentView rebuilds
                        setupDone = true
                    }
                } else {
                    ContentView(
                        repository: repository,
                        currentStudentId: student.id,
                        onSignOut: {
                            loggedInStudentId = nil
                            setupDone = false
                        }
                    )
                }
            } else {
                LoginView(repository: repository, onLogin: { student in
                    loggedInStudentId = student.id
                    setupDone = student.semesterPlan != nil
                })
            }
        }
    }
}
