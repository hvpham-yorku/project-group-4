import SwiftUI

struct ProfileView: View {
    @ObservedObject var student: Student
    let repository: StudentRepositoryReal

    @State private var showDeleteAlert = false
    @State private var deleteError: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Profile")
                .font(.largeTitle.bold())

            Text("Name: \(student.name)")
            Text("ID: \(student.id)")
            Text("Balance: $\(student.balance(), specifier: "%.2f")")

            if let deleteError {
                Text(deleteError)
                    .foregroundColor(.red)
            }

            Button("Delete Account") {
                showDeleteAlert = true
            }
            .tint(.red)
            .alert("Delete Account", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    deleteStudent()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this account?")
            }

            Spacer()
        }
        .padding()
    }

    private func deleteStudent() {
        if student.id == "S001" || student.id == "S002" || student.id == "T001" {
            deleteError = "Cannot delete demo account"
            return
        }

        repository.deleteStudent(student)
        deleteError = nil
    }
}
