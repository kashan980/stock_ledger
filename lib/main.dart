import 'package:flutter/material.dart';
import 'package:personal_stock/presentation/screens/transaction_form/transaction_form_screen.dart';

void main() {
  runApp(
    const PersonalStockApp(),
  );
}

class PersonalStockApp extends StatelessWidget {
  const PersonalStockApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Stock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const TransactionFormScreen(),
    );
  }
}