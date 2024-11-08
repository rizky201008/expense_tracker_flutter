import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final Function(Expense) addExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
      initialDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: const Text("Invalid Input"),
              content: const Text(
                  "Please enter a valid title, amount and date and fill all required input"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text("Okay"),
                )
              ],
            ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: const Text("Invalid Input"),
              content: const Text(
                  "Please enter a valid title, amount and date and fill all required input"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text("Okay"),
                )
              ],
            ),
      );
    }
  }

  void _submitExpenseDate() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text
        .trim()
        .isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    }
    final newExpense = Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );
    widget.addExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery
        .of(context)
        .viewInsets
        .bottom;
    return LayoutBuilder(builder: (ctx, constraint) {
      final width = constraint.maxWidth;

      return SizedBox(
        // biar full screen
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          decoration:
                          const InputDecoration(label: Text("Title")),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              label: Text("Amount"), prefixText: "\$"),
                        ),
                      ),
                    ],
                  )
                else
                // Title input
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(label: Text("Title")),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) =>
                                DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == null) {
                                return;
                              }
                              _selectedCategory = value;
                            });
                          }),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? "No date selected"
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.date_range),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                else
                // Date input
                  Row(
                    children: [
                      // Amount input
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              label: Text("Amount"), prefixText: "\$"),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? "No date selected"
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.date_range),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: _submitExpenseDate,
                        child: const Text("Add expense"),
                      ),
                    ],
                  )
                else
                // Buttons
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) =>
                                DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == null) {
                                return;
                              }
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: _submitExpenseDate,
                        child: const Text("Add expense"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
