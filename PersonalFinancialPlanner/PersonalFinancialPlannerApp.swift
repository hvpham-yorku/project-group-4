import SwiftUI

@main
struct PersonalFinancialPlannerApp: App {
    
    @StateObject private var repository = StudentRepositoryStub()
    @State private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView(repository: repository)
            } else {
                LoginView(
                    repository: repository,
                    loggedIn: $isLoggedIn
                )
            }
        }
    }
}
