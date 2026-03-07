import XCTest
@testable import PersonalFinancialPlanner

final class BudgetTests: XCTestCase {
    
    func testRemainingBudgetReturnsCorrectValue() {
        let budget = Budget(category: "Food", limit: 500)
        
        let remaining = budget.remaining(spent: 200)
        
        XCTAssertEqual(remaining, 300)
    }
    
    func testRemainingBudgetCanBeNegativeWhenOverspent() {
        let budget = Budget(category: "Food", limit: 300)
        
        let remaining = budget.remaining(spent: 450)
        
        XCTAssertEqual(remaining, -150)
    }
}
