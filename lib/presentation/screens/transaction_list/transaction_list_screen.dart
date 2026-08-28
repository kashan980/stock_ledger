import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/transaction_list_provider.dart';
import '../transaction_form/transaction_form_screen.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionListProvider()..loadTransactions(),
      child: const _TransactionListView(),
    );
  }
}

class _TransactionListView extends StatelessWidget {
  const _TransactionListView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionListProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(TransactionListProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Text(provider.errorMessage!),
      );
    }

    if (provider.transactions.isEmpty) {
      return const Center(
        child: Text('No transactions found.'),
      );
    }

    return ListView.builder(
        itemCount: provider.transactions.length,
        itemBuilder: (context, index) {
          final transaction = provider.transactions[index];

          //     return ListTile(
          //       title: Text(transaction.symbol),
          //       subtitle: Text(
          //         '${transaction.transactionType} • '
          //             '${transaction.quantity} shares • '
          //             '${transaction.purchasePrice}',
          //       ),
          //       trailing: Text(transaction.transactionDate),
          //     );
          //   },
          // );

          // return ListTile(
          //   title: Text(transaction.symbol),
          //   subtitle: Text(
          //     '${transaction.transactionType} • '
          //         '${transaction.quantity} shares • '
          //         '${transaction.purchasePrice}',
          //   ),
          //   // trailing: IconButton(
          //   //   icon: const Icon(Icons.edit),
          //   //   onPressed: () {
          //   //     Navigator.push(
          //   //       context,
          //   //       MaterialPageRoute(
          //   //         builder: (_) => TransactionFormScreen(
          //   //           transaction: transaction,
          //   //         ),
          //   //       ),
          //   //     );
          //   //   },
          //   // ),
          //   trailing: IconButton(
          //     icon: const Icon(Icons.edit),
          //     onPressed: () async {
          //       await Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => TransactionFormScreen(
          //             transaction: transaction,
          //           ),
          //         ),
          //       );
          //
          //       provider.loadTransactions();
          //     },
          //   ),
          // );
          return ListTile(
            title: Text(transaction.symbol),
            subtitle: Text(
              '${transaction.transactionType} • '
                  '${transaction.quantity} shares • '
                  '${transaction.purchasePrice}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransactionFormScreen(
                          transaction: transaction,
                        ),
                      ),
                    );

                    provider.loadTransactions();
                  },
                ),

                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final success =
                    await provider.deleteTransaction(
                      transaction.id!,
                    );

                    if (!context.mounted) return;

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Transaction deleted successfully',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
    );
  }
}