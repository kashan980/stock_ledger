// import 'package:flutter/material.dart';
//
// import '../../data/models/transaction_model.dart';
// import '../../data/repositories/transaction_repository.dart';
//
// class TransactionFormProvider extends ChangeNotifier {
//   final TransactionRepository _repository =
//   TransactionRepository();
//
//   // Form key
//   final formKey = GlobalKey<FormState>();
//
//   // Controllers
//   final symbolController = TextEditingController();
//   final quantityController = TextEditingController();
//   final priceController = TextEditingController();
//   final notesController = TextEditingController();
//
//   // Transaction type
//   String? transactionType;
//
//   // Transaction date
//   DateTime transactionDate = DateTime.now();
//
//   // Loading
//   bool isSaving = false;
//
//   // --------------------------------------------------
//   // TRANSACTION TYPE
//   // --------------------------------------------------
//
//   void setTransactionType(String? value) {
//     transactionType = value;
//     notifyListeners();
//   }
//
//   // --------------------------------------------------
//   // DATE
//   // --------------------------------------------------
//
//   Future<void> selectDate(BuildContext context) async {
//     final now = DateTime.now();
//
//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: transactionDate,
//       firstDate: DateTime(2000),
//       lastDate: now,
//     );
//
//     if (selectedDate != null) {
//       transactionDate = selectedDate;
//       notifyListeners();
//     }
//   }
//
//   // --------------------------------------------------
//   // FORMAT DATE
//   // --------------------------------------------------
//
//   String formatDate(DateTime date) {
//     final day = date.day.toString().padLeft(2, '0');
//     final month = date.month.toString().padLeft(2, '0');
//     final year = date.year.toString();
//
//     return '$day/$month/$year';
//   }
//
//   // --------------------------------------------------
//   // SUBMIT
//   // --------------------------------------------------
//
//   Future<bool> submit() async {
//     if (!formKey.currentState!.validate()) {
//       return false;
//     }
//
//     final transaction = TransactionModel(
//       symbol: symbolController.text.trim(),
//       transactionType: transactionType!,
//       quantity: int.parse(
//         quantityController.text.trim(),
//       ),
//       purchasePrice: double.parse(
//         priceController.text.trim(),
//       ),
//       transactionDate:
//       transactionDate.toIso8601String(),
//       notes: notesController.text.trim().isEmpty
//           ? null
//           : notesController.text.trim(),
//     );
//
//     isSaving = true;
//     notifyListeners();
//
//     try {
//       await _repository.insertTransaction(
//         transaction,
//       );
//
//       return true;
//     } catch (e) {
//       return false;
//     } finally {
//       isSaving = false;
//       notifyListeners();
//     }
//   }
//
//   // --------------------------------------------------
//   // CLEAR FORM
//   // --------------------------------------------------
//
//   void clearForm() {
//     symbolController.clear();
//     quantityController.clear();
//     priceController.clear();
//     notesController.clear();
//
//     transactionType = null;
//     transactionDate = DateTime.now();
//
//     notifyListeners();
//   }
//
//   // --------------------------------------------------
//   // DISPOSE
//   // --------------------------------------------------
//
//   @override
//   void dispose() {
//     symbolController.dispose();
//     quantityController.dispose();
//     priceController.dispose();
//     notesController.dispose();
//
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// //import '../../core/validators/form_validators.dart';
// import '../../data/models/transaction_model.dart';
// import '../../data/repositories/transaction_repository.dart';
//
// class TransactionFormProvider extends ChangeNotifier {
//   final TransactionRepository _repository = TransactionRepository();
//
//   // Form key
//   final formKey = GlobalKey<FormState>();
//
//   // Controllers
//   final symbolController = TextEditingController();
//   final quantityController = TextEditingController();
//   final priceController = TextEditingController();
//   final notesController = TextEditingController();
//
//   // Form values
//   String? transactionType;
//   DateTime transactionDate = DateTime.now();
//
//   // Loading state
//   bool isSaving = false;
//
//   // --------------------------------------------------
//   // DATE PICKER
//   // --------------------------------------------------
//
//   Future<void> selectDate(BuildContext context) async {
//     final now = DateTime.now();
//
//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: transactionDate,
//       firstDate: DateTime(2000),
//       lastDate: now,
//     );
//
//     if (selectedDate != null) {
//       transactionDate = selectedDate;
//       notifyListeners();
//     }
//   }
//
//   // --------------------------------------------------
//   // TRANSACTION TYPE
//   // --------------------------------------------------
//
//   void setTransactionType(String? value) {
//     transactionType = value;
//     notifyListeners();
//   }
//
//   // --------------------------------------------------
//   // SUBMIT
//   // --------------------------------------------------
//
//   Future<bool> submit() async {
//     // Validate form
//     if (!formKey.currentState!.validate()) {
//       return false;
//     }
//
//     // Create transaction object
//     final transaction = TransactionModel(
//       symbol: symbolController.text.trim(),
//       transactionType: transactionType!,
//       quantity: int.parse(
//         quantityController.text.trim(),
//       ),
//       purchasePrice: double.parse(
//         priceController.text.trim(),
//       ),
//       transactionDate: transactionDate.toIso8601String(),
//       notes: notesController.text
//           .trim()
//           .isEmpty
//           ? null
//           : notesController.text.trim(),
//     );
//
//     isSaving = true;
//     notifyListeners();
//
//       try {
//         // Save to database
//         await _repository.insertTransaction(transaction);
//
//         return true;
//       } catch (e) {
//         rethrow;
//       } finally {
//         isSaving = false;
//         notifyListeners();
//       }
//     }
//
//   // --------------------------------------------------
//   // DISPOSE
//   // --------------------------------------------------
//
//   @override
//   void dispose() {
//     symbolController.dispose();
//     quantityController.dispose();
//     priceController.dispose();
//     notesController.dispose();
//
//     super.dispose();
//   }
// }





import 'package:flutter/material.dart';

import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';

class TransactionFormProvider extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  // Existing transaction
  // null = Add mode
  // not null = Edit mode
  final TransactionModel? transaction;

  TransactionFormProvider({
    this.transaction,
  });

  // Form key
  final formKey = GlobalKey<FormState>();

  // Controllers
  final symbolController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final notesController = TextEditingController();

  // Form values
  String? transactionType;
  DateTime transactionDate = DateTime.now();

  // Loading state
  bool isSaving = false;

  // --------------------------------------------------
  // INITIALIZE FORM
  // --------------------------------------------------

  void initializeForm() {
    if (transaction == null) {
      return;
    }

    symbolController.text = transaction!.symbol;
    quantityController.text =
        transaction!.quantity.toString();
    priceController.text =
        transaction!.purchasePrice.toString();
    notesController.text =
        transaction!.notes ?? '';

    transactionType =
        transaction!.transactionType;

    transactionDate = DateTime.parse(
      transaction!.transactionDate,
    );

    notifyListeners();
  }

  // --------------------------------------------------
  // DATE PICKER
  // --------------------------------------------------

  Future<void> selectDate(BuildContext context) async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: transactionDate,
      firstDate: DateTime(2000),
      lastDate: now,
    );

    if (selectedDate != null) {
      transactionDate = selectedDate;
      notifyListeners();
    }
  }

  // --------------------------------------------------
  // TRANSACTION TYPE
  // --------------------------------------------------

  void setTransactionType(String? value) {
    transactionType = value;
    notifyListeners();
  }

  // --------------------------------------------------
  // SUBMIT
  // --------------------------------------------------

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final updatedTransaction = TransactionModel(
      id: transaction?.id,
      symbol: symbolController.text.trim(),
      transactionType: transactionType!,
      quantity: int.parse(
        quantityController.text.trim(),
      ),
      purchasePrice: double.parse(
        priceController.text.trim(),
      ),
      transactionDate:
      transactionDate.toIso8601String(),
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
    );

    isSaving = true;
    notifyListeners();

    try {
      if (transaction == null) {
        // ADD
        await _repository.insertTransaction(
          updatedTransaction,
        );
      } else {
        // EDIT
        await _repository.updateTransaction(
          updatedTransaction,
        );
      }

      return true;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------
  // DISPOSE
  // --------------------------------------------------

  @override
  void dispose() {
    symbolController.dispose();
    quantityController.dispose();
    priceController.dispose();
    notesController.dispose();

    super.dispose();
  }
}