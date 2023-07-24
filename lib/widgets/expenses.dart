import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 1999,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 1999,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(onAddExpense: _addExpense);
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Expense Deleted"),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(
                  expenseIndex,
                  expense,
                );
              });
            }),
      ),
    );
  }

  @override
  Widget build(context) {
    final width = (MediaQuery.of(context).size.width);
    final height = (MediaQuery.of(context).size.height);
    // Widget orient;
    // if (width >height){
    //   orient = Row();
    // }
    // else{
    //   orient = Column();
    // }
    Widget mainContent = const Center(
      child: Text("No Expenses Found"),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          onRemoveExpense: _removeExpense, expenses: _registeredExpenses);
    }

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(255, 8, 93, 239),
        title: const Text("Flutter ExpenseTracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: (width > height)
          ? Row(children: [
              Expanded(child: Chart(expenses: _registeredExpenses)),
              Expanded(
                child: mainContent,
              ),
            ])
          : Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
