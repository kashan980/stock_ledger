import 'package:flutter/material.dart';

import 'screens/transaction_form_screen.dart';

void main() {
  runApp(const StockLedgerApp());
}

class StockLedgerApp extends StatelessWidget {
  const StockLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Ledger',
      // We will use a standard dark theme since it fits financial apps nicely
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      // This tells the app to open your new Form Screen immediately
      home: const TransactionFormScreen(),
    );
  }
}
