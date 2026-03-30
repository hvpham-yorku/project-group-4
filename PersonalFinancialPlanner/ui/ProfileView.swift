import SwiftUI

struct ProfileView: View {
    @ObservedObject var student: Student
    @ObservedObject var repository: StudentRepositoryReal
    
    @State private var showDeleteAlert = false
    @State private var deleteError: String? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Profile")
                .font(.largeTitle.bold())
            
            Text("Name: \(student.name)")
            Text("ID: \(student.id)")
            Text("Balance: $\(student.balance(), specifier: "%.2f")")
            
            if let error = deleteError {
                Text(error).foregroundColor(.red)
            }
            
            Button("Delete Account") {
                showDeleteAlert = true
            }
            .tint(.red)
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete this student?"),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteStudent()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func deleteStudent() {
        if student.id == "S001" || student.id == "S002" {
            deleteError = "Cannot delete tester account"
            return
        }
        repository.deleteStudent(student)
        deleteError = nil
    }
}
