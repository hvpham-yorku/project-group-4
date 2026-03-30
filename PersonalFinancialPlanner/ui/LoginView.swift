import SwiftUI

struct LoginView: View {
    @ObservedObject var repository: StudentRepositoryStub
    var onLogin: (Student) -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.06, green: 0.07, blue: 0.12),
                         Color(red: 0.08, green: 0.10, blue: 0.18)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.15))
                            .frame(width: 72, height: 72)
                        Image(systemName: "wallet.bifold.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55))
                    }
                    Text("UniWallet")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("York University Financial Planner")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.bottom, 44)

                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                        TextField("", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(14)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                        SecureField("", text: $password)
                            .padding(14)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }

                    if !errorMessage.isEmpty {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.system(size: 12))
                            Text(errorMessage)
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Color(red: 1.0, green: 0.38, blue: 0.38))
                    }

                    Button { login() } label: {
                        Text("Sign In")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color(red: 0.2, green: 0.85, blue: 0.55))
                            .cornerRadius(14)
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 28)

                Spacer()

                VStack(spacing: 4) {
                    Text("Test accounts")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.3))
                    Text("alice@yorku.ca / Alice123")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.25))
                    Text("bob@yorku.ca / Bob123")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.25))
                    Text("tester@yorku.ca / Test1234")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.25))
                }
                .padding(.bottom, 30)
            }
        }
    }

    private func login() {
        if let student = repository.login(email: email, password: password) {
            onLogin(student)
        } else {
            errorMessage = "Invalid email or password"
        }
    }
}
