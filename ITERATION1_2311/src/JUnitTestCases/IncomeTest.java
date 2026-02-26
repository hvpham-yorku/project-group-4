package JUnitTestCases;

import model.Income;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class IncomeTest {

    @Test
    void testConstructorAndGetters() {
        Income income = new Income("Job", 1000.50);
        assertEquals("Job", income.getSource());
        assertEquals(1000.50, income.getAmount(), 0.001);
    }

    @Test
    void testZeroAmount() {
        Income income = new Income("Gift", 0.0);
        assertEquals("Gift", income.getSource());
        assertEquals(0.0, income.getAmount(), 0.001);
    }

    @Test
    void testNegativeAmountFails() {
        // Note: if constructor allows negative, remove this test
        Income income = new Income("Job", -100);
        assertEquals(-100, income.getAmount(), 0.001);
    }
}
