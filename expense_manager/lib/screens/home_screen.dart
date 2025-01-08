import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../screens/add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List'),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.expenses.length,
            itemBuilder: (context, index) {
              final expense = provider.expenses[index];
              return ListTile(
                title: Text('${expense.payee} - \$${expense.amount}'),
                subtitle: Text(
                  'Category: ${expense.categoryId} - Date: ${expense.date.toIso8601String()}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExpenseScreen(
                        initialExpense: expense, // Use the correct parameter
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(), // No parameter needed
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Expense',
      ),
    );
  }
}