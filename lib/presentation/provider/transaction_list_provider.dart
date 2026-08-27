import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';

class TransactionListProvider extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  List<TransactionModel> _transactions = [];

  bool _isLoading = false;

  String? _errorMessage;

  List<TransactionModel> get transactions => _transactions;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _repository.getTransactions();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}