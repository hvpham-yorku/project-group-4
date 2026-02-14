package JUnitTestCases;

import model.Expense;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ExpenseTest {

    @Test
    void testConstructorAndGetters() {
        Expense expense = new Expense("Food", 25.75);
        assertEquals("Food", expense.getCategory());
        assertEquals(25.75, expense.getAmount(), 0.001);
    }

    @Test
    void testZeroAmount() {
        Expense expense = new Expense("Savings", 0.0);
        assertEquals("Savings", expense.getCategory());
        assertEquals(0.0, expense.getAmount(), 0.001);
    }

    @Test
    void testNegativeAmount() {
        Expense expense = new Expense("Refund", -50.0);
        assertEquals("Refund", expense.getCategory());
        assertEquals(-50.0, expense.getAmount(), 0.001);
    }
}
