package JUnitTestCases;

import model.Income;
import model.Expense;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import repository.FakeFinanceRepository;

import static org.junit.jupiter.api.Assertions.*;

public class FakeFinanceRepositoryTest {

    private FakeFinanceRepository repo;

    @BeforeEach
    void setUp() {
        repo = new FakeFinanceRepository();
    }

    @Test
    void testAddAndGetIncome() {
        Income income = new Income("Job", 1000);
        repo.addIncome(income);
        assertEquals(1, repo.getAllIncome().size());
        assertEquals(income, repo.getAllIncome().get(0));
    }

    @Test
    void testMultipleIncomes() {
        repo.addIncome(new Income("Job", 1000));
        repo.addIncome(new Income("Freelance", 500));
        assertEquals(2, repo.getAllIncome().size());
        assertEquals(1000, repo.getAllIncome().get(0).getAmount(), 0.001);
        assertEquals(500, repo.getAllIncome().get(1).getAmount(), 0.001);
    }

    @Test
    void testAddAndGetExpense() {
        Expense expense = new Expense("Food", 200);
        repo.addExpense(expense);
        assertEquals(1, repo.getAllExpenses().size());
        assertEquals(expense, repo.getAllExpenses().get(0));
    }

    @Test
    void testMultipleExpenses() {
        repo.addExpense(new Expense("Food", 200));
        repo.addExpense(new Expense("Rent", 1000));
        assertEquals(2, repo.getAllExpenses().size());
    }

    @Test
    void testEmptyListsInitially() {
        assertTrue(repo.getAllIncome().isEmpty());
        assertTrue(repo.getAllExpenses().isEmpty());
    }
}
