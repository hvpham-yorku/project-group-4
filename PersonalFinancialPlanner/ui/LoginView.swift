//
//  Untitled.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-03-29.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var repository: StudentRepositoryStub
    @Binding var loggedIn: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("UniWallet")
                .font(.largeTitle.bold())

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Login") {
                login()
            }
            .buttonStyle(.borderedProminent)

            Spacer()

            Text("""
Test accounts:
alice@yorku.ca / Alice123
bob@yorku.ca / Bob123
tester@yorku.ca / Test1234
""")
            .font(.caption)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
        }
        .padding()
    }

    private func login() {
        if repository.login(email: email, password: password) != nil {
            loggedIn = true
        } else {
            errorMessage = "Invalid email or password"
        }
    }
}
