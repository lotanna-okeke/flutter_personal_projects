import 'package:expense_tracker/widgets/edit_expense.dart';
import 'package:flutter/material.dart';

import '../../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(
      {super.key,
      required this.expense,
      required this.onDeleteExpense,
      required this.editExpenseIndex,
      required this.onEditExpense});

  final Expense expense;
  final void Function(Expense expense) onDeleteExpense;
  final int Function(Expense expense) editExpenseIndex;
  final void Function({required Expense edittedExpense, required int index})
      onEditExpense;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final sideways = height < width;

    void _openEditExpenseOverlay(Expense editExpense) {
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        // isScrollControlled: true,
        isScrollControlled: sideways ? true : false,
        builder: (ctx) => EditExpense(
          expense: editExpense,
          editExpenseIndex: editExpenseIndex,
          onEditExpense: onEditExpense,
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${expense.title}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _openEditExpenseOverlay(expense);
                      },
                      icon: Icon(Icons.edit),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        onDeleteExpense(expense);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8),
                    Text(
                      expense.formattedDate,
                      // style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
