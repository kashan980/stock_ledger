import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/transaction_list_provider.dart';

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

        return ListTile(
          title: Text(transaction.symbol),
          subtitle: Text(
            '${transaction.transactionType} • '
                '${transaction.quantity} shares • '
                '${transaction.purchasePrice}',
          ),
          trailing: Text(transaction.transactionDate),
        );
      },
    );
  }
}