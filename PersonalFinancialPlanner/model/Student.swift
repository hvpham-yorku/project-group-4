import Foundation

class Student: Identifiable, ObservableObject {
    let id: String
    let name: String
    let email: String
    let password: String
    
    @Published var transactions: [Transaction]
    
    init(id: String, name: String, email: String, password: String, transactions: [Transaction] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.transactions = transactions
    }
    
    func balance() -> Double {
        transactions.reduce(0) { result, tx in
            result + (tx.type == "Income" ? tx.amount : -tx.amount)
        }
    }
}
