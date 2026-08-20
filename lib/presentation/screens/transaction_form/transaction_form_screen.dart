import 'package:flutter/material.dart';
import '../../../core/validators/form_validators.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_date_field.dart';
import '../../widgets/app_drop_down.dart';
import '../../widgets/app_text_field.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({
    super.key,
  });

  @override
  State<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState
    extends State<TransactionFormScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _symbolController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  // Repository
  final TransactionRepository _repository =
  TransactionRepository();

  // Form values
  String? _transactionType;

  DateTime _transactionDate = DateTime.now();

  // Loading state
  bool _isSaving = false;

  @override
  void dispose() {
    _symbolController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  // --------------------------------------------------
  // DATE PICKER
  // --------------------------------------------------

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2000),
      lastDate: now,
    );

    if (selectedDate != null) {
      setState(() {
        _transactionDate = selectedDate;
      });
    }
  }

  // --------------------------------------------------
  // SUBMIT
  // --------------------------------------------------

  Future<void> _submit() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create transaction object
    final transaction = TransactionModel(
      symbol: _symbolController.text.trim(),
      transactionType: _transactionType!,
      quantity: int.parse(
        _quantityController.text.trim(),
      ),
      purchasePrice: double.parse(
        _priceController.text.trim(),
      ),
      transactionDate:
      _transactionDate.toIso8601String(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    setState(() {
      _isSaving = true;
    });

    try {
      // Save to database
      await _repository.insertTransaction(
        transaction,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Transaction saved successfully',
          ),
        ),
      );

      //Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save transaction: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // --------------------------------------------------
  // UI
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode:
          AutovalidateMode.onUserInteraction,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [

              // Stock ticker
              AppTextField(
                controller: _symbolController,
                label: 'Stock Ticker',
                hint: 'e.g. UBL',
                textCapitalization:
                TextCapitalization.characters,
                validator:
                FormValidators.stockSymbol,
              ),

              const SizedBox(height: 16),

              // Transaction type
              AppDropdown<String>(
                value: _transactionType,
                label: 'Transaction Type',
                items: const [
                  DropdownMenuItem(
                    value: 'BUY',
                    child: Text('BUY'),
                  ),
                  DropdownMenuItem(
                    value: 'SELL',
                    child: Text('SELL'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _transactionType = value;
                  });
                },
                validator:
                FormValidators.transactionType,
              ),

              const SizedBox(height: 16),

              // Quantity
              AppTextField(
                controller: _quantityController,
                label: 'Quantity',
                hint: 'e.g. 10',
                keyboardType:
                TextInputType.number,
                validator:
                FormValidators.quantity,
              ),

              const SizedBox(height: 16),

              // Price
              AppTextField(
                controller: _priceController,
                label: 'Price Per Share',
                hint: 'e.g. 150.50',
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator:
                FormValidators.price,
              ),

              const SizedBox(height: 16),

              // Transaction date
              AppDateField(
                date: _transactionDate,
                label: 'Transaction Date',
                onTap: _selectDate,
              ),

              const SizedBox(height: 16),

              // Notes
              AppTextField(
                controller: _notesController,
                label: 'Notes',
                hint: 'Optional',
                maxLength: 100,
                maxLines: 3,
                validator:
                FormValidators.notes,
              ),

              const SizedBox(height: 24),

              // Submit button
              AppButton(
                text: 'Submit',
                onPressed: _submit,
                isLoading: _isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}