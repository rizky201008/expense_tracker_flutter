import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      cardTheme: const CardTheme(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8000)),
    ),
    home: const Expenses(),
  ));
}
