package repository;

import model.Income;
import model.Expense;

import java.util.ArrayList;
import java.util.List;

public class FakeFinanceRepository implements FinanceRepository {

    private List<Income> incomes = new ArrayList<>();
    private List<Expense> expenses = new ArrayList<>();

    public void addIncome(Income income) {
        incomes.add(income);
    }

    public void addExpense(Expense expense) {
        expenses.add(expense);
    }

    public List<Income> getAllIncome() {
        return incomes;
    }

    public List<Expense> getAllExpenses() {
        return expenses;
    }
}
