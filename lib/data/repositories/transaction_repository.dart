//import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> insertTransaction(
      TransactionModel transaction,
      ) async {
    _validateTransaction(transaction);

    final db = await _databaseHelper.database;

    return await db.insert(
      DatabaseHelper.tableTransactions,
      transaction.toMap(),
    );
  }







  Future<List<TransactionModel>> getTransactions() async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableTransactions,
      orderBy: 'transaction_date DESC',
    );

    return maps
        .map((map) => TransactionModel.fromMap(map))
        .toList();
  }
  // this for for get transaction which will be used to show the transaction in the detail page



  Future<int> updateTransaction(
      TransactionModel transaction,
      ) async {
    _validateTransaction(transaction);

    final db = await _databaseHelper.database;

    return await db.update(
      DatabaseHelper.tableTransactions,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
  //added for update transaction





  Future<int> deleteTransaction(int id) async {
    final db = await _databaseHelper.database;

    return await db.delete(
      DatabaseHelper.tableTransactions,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  //added for delete transactions


  void _validateTransaction(
      TransactionModel transaction,
      ) {
    final symbolRegex = RegExp(r'^[A-Z]{3,6}$');

    if (!symbolRegex.hasMatch(transaction.symbol)) {
      throw ArgumentError(
        'Symbol must contain 3 to 6 uppercase letters.',
      );
    }

    if (transaction.transactionType != 'BUY' &&
        transaction.transactionType != 'SELL') {
      throw ArgumentError(
        'Transaction type must be BUY or SELL.',
      );
    }

    if (transaction.quantity <= 0) {
      throw ArgumentError(
        'Quantity must be greater than 0.',
      );
    }

    if (transaction.purchasePrice <= 0) {
      throw ArgumentError(
        'Purchase price must be greater than 0.',
      );
    }

    final priceString =
    transaction.purchasePrice.toString();

    if (priceString.contains('.')) {
      final decimalPlaces =
          priceString.split('.').last.length;

      if (decimalPlaces > 2) {
        throw ArgumentError(
          'Purchase price cannot have more than 2 decimal places.',
        );
      }
    }

    final transactionDate =
    DateTime.tryParse(transaction.transactionDate);

    if (transactionDate == null) {
      throw ArgumentError(
        'Invalid transaction date.',
      );
    }

    final today = DateTime.now();

    final selectedDate = DateTime(
      transactionDate.year,
      transactionDate.month,
      transactionDate.day,
    );

    final currentDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    if (selectedDate.isAfter(currentDate)) {
      throw ArgumentError(
        'Transaction date cannot be in the future.',
      );
    }

    if (transaction.notes != null &&
        transaction.notes!.length > 100) {
      throw ArgumentError(
        'Notes cannot exceed 100 characters.',
      );
    }
  }
}