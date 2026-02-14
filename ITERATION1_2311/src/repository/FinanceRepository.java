package repository;

import model.Income;
import model.Expense;
import java.util.List;

public interface FinanceRepository {

    void addIncome(Income income);
    void addExpense(Expense expense);

    List<Income> getAllIncome();
    List<Expense> getAllExpenses();
}
