import 'package:flutter/material.dart';
import 'package:personal_stock/presentation/widgets/app_button.dart';

import '../transaction_form/transaction_form_screen.dart';
import '../transaction_list/transaction_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Stock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  AppButton(
                    text: 'View Transactions',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransactionListScreen(),
                        ),
                      );
                    },
                  ),
                ]
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  AppButton(
                    text: 'Add Transaction',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransactionFormScreen(),
                        ),
                      );
                    },
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}