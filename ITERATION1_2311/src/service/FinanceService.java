package service;

import repository.FinanceRepository;
import model.Income;
import model.Expense;

import java.util.HashMap;
import java.util.Map;

public class FinanceService {

    private FinanceRepository repo;

    public FinanceService(FinanceRepository repo) {
        this.repo = repo;
    }

    public void addIncome(String source, double amount) {
        repo.addIncome(new Income(source, amount));
    }

    public void addExpense(String category, double amount) {
        repo.addExpense(new Expense(category, amount));
    }

    public double calculateBalance() {

        double incomeTotal = repo.getAllIncome()
                .stream()
                .mapToDouble(Income::getAmount)
                .sum();

        double expenseTotal = repo.getAllExpenses()
                .stream()
                .mapToDouble(Expense::getAmount)
                .sum();

        return incomeTotal - expenseTotal;
    }

    public Map<String, Double> groupExpensesByCategory() {

        Map<String, Double> result = new HashMap<>();

        for (Expense e : repo.getAllExpenses()) {
            result.put(
                    e.getCategory(),
                    result.getOrDefault(e.getCategory(), 0.0) + e.getAmount()
            );
        }

        return result;
    }
}
