import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'expenses list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

final List<Expense> _registeredExpenses = [
  Expense(
    title: 'Flutter Course',
    amount: 4.5,
    date: DateTime.now(),
    category: Category.work,
  ),
  Expense(
    title: 'Cinema',
    amount: 6.78,
    date: DateTime.now(),
    category: Category.leisure,
  ),
];

class _ExpensesState extends State<Expenses> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(_addExpense),
    );
  }

  void _addExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense newExpense) {
    // final expenseIndex = _registeredExpenses.indexWhere((element) => element == newExpense); //or
    final expenseIndex = _registeredExpenses.indexOf(newExpense);
    setState(() {
      _registeredExpenses.remove(newExpense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, newExpense);
            });
          },
        ),
      ),
    );
  }

  int editExpenseIndex(Expense editExpense) {
    final expenseIndex = _registeredExpenses.indexOf(editExpense);
    return expenseIndex;
  }

  void _editExpense({required Expense edittedExpense, required int index}) {
    setState(() {
      _registeredExpenses[index] = edittedExpense;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);
    // print(MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final notSideways = width < height;

    Widget mainContent = const Center(
      child: Text(
        'No expense found. Start adding some!',
        style: TextStyle(fontSize: 20),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        OnRemoveExpense: _removeExpense,
        editExpenseIndex: editExpenseIndex,
        onEditExpense: _editExpense,
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('FLutter Expense Tracker'),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
            // IconButton(
            //   onPressed: _openAddExpenseOverlay,
            //   icon: const Icon(Icons.search),
            // ),
          ],
        ),
        body: notSideways
            ? Column(
                children: [
                  //toolbar with add button
                  Chart(expenses: _registeredExpenses),
                  Expanded(
                    child: mainContent,
                  )
                ],
              )
            : Row(
                children: [
                  //toolbar with add button
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(
                    child: mainContent,
                  )
                ],
              ));
  }
}
