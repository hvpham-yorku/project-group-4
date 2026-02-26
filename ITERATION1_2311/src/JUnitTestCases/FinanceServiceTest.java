package JUnitTestCases;

import repository.FakeFinanceRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import service.FinanceService;

import static org.junit.jupiter.api.Assertions.*;

public class FinanceServiceTest {

    private FakeFinanceRepository repo;
    private FinanceService service;

    @BeforeEach
    void setUp() {
        repo = new FakeFinanceRepository();
        service = new FinanceService(repo);
    }

    @Test
    void testBalanceCalculation_incomeOnly() {
        service.addIncome("Job", 1000);
        assertEquals(1000, service.calculateBalance(), 0.001);
    }

    @Test
    void testBalanceCalculation_expenseOnly() {
        service.addExpense("Food", 200);
        assertEquals(-200, service.calculateBalance(), 0.001);
    }

    @Test
    void testBalanceCalculation_both_incomeExceedsExpense() {
        service.addIncome("Job", 1000);
        service.addExpense("Food", 200);
        assertEquals(800, service.calculateBalance(), 0.001);
    }

    @Test
    void testBalanceCalculation_both_expenseExceedsIncome() {
        service.addIncome("Job", 100);
        service.addExpense("Rent", 200);
        assertEquals(-100, service.calculateBalance(), 0.001);
    }

    @Test
    void testBalanceCalculation_zeroBalance() {
        service.addIncome("Job", 100);
        service.addExpense("Food", 100);
        assertEquals(0, service.calculateBalance(), 0.001);
    }

    @Test
    void testBalanceCalculation_noTransactions() {
        assertEquals(0, service.calculateBalance(), 0.001);
    }

    @Test
    void testGroupExpensesByCategory_singleCategory() {
        service.addExpense("Food", 50);
        service.addExpense("Food", 30);

        var result = service.groupExpensesByCategory();
        assertEquals(80, result.get("Food"), 0.001);
    }

    @Test
    void testGroupExpensesByCategory_multipleCategories() {
        service.addExpense("Food", 50);
        service.addExpense("Rent", 1000);
        service.addExpense("Food", 30);

        var result = service.groupExpensesByCategory();
        assertEquals(80, result.get("Food"), 0.001);
        assertEquals(1000, result.get("Rent"), 0.001);
    }

    @Test
    void testGroupExpensesByCategory_noExpenses() {
        var result = service.groupExpensesByCategory();
        assertTrue(result.isEmpty());
    }
}
