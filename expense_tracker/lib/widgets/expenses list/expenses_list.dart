import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses%20list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  ExpensesList(
      {super.key, required this.expenses, required this.OnRemoveExpense, required this.editExpenseIndex, required this.onEditExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) OnRemoveExpense;
  final int Function(Expense expense) editExpenseIndex;
  final void Function({required Expense edittedExpense, required int index})
      onEditExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          // margin: EdgeInsets.symmetric(
          //     horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin == null
                  ? 16
                  : Theme.of(context).cardTheme.margin!.horizontal),
        ),
        onDismissed: (direction) {
          OnRemoveExpense(
            expenses[index],
          );
        },
        child: ExpenseItem(
          expense: expenses[index],
          onDeleteExpense: OnRemoveExpense,
          editExpenseIndex: editExpenseIndex,
          onEditExpense: onEditExpense,
        ),
      ),
    );
  }
}
