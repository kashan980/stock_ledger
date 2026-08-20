import 'package:flutter/material.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  // 1. The Form Key
  final _formKey = GlobalKey<FormState>();

  // 2. Text Editing Controllers
  final _tickerController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  // State Variables
  String _transactionType = 'BUY';
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _tickerController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Helper method to show the Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // STRICT RULE: No future dates allowed
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // The Submission Logic
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If validation passes, this block runs.
      // We will hook this up to SQLite in the next step!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Validated! Ready to save to DB.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              // --- 1. STOCK TICKER ---
              TextFormField(
                controller: _tickerController,
                decoration: const InputDecoration(
                  labelText: 'Stock Ticker (e.g. PSO)',
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ticker cannot be empty';
                  }
                  // RegEx: Only uppercase letters, strictly 3 to 6 characters long
                  if (!RegExp(r'^[A-Z]{3,6}$').hasMatch(value)) {
                    return 'Must be 3-6 uppercase letters';
                  }
                  return null; // Null means the input is valid!
                },
              ),
              const SizedBox(height: 16),

              // --- 2. TRANSACTION TYPE ---
              DropdownButtonFormField<String>(
                value: _transactionType,
                decoration: const InputDecoration(
                  labelText: 'Transaction Type',
                ),
                items: const [
                  DropdownMenuItem(value: 'BUY', child: Text('BUY')),
                  DropdownMenuItem(value: 'SELL', child: Text('SELL')),
                ],
                onChanged: (value) {
                  setState(() {
                    _transactionType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // --- 3. QUANTITY ---
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a quantity';

                  final intValue = int.tryParse(value);
                  if (intValue == null || intValue <= 0) {
                    return 'Must be a whole number greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- 4. PURCHASE PRICE ---
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price Per Share'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a price';

                  // RegEx: Allows numbers, optionally followed by a dot and up to 2 decimals
                  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
                    return 'Must be a valid price (max 2 decimal places)';
                  }

                  final doubleValue = double.tryParse(value);
                  if (doubleValue == null || doubleValue <= 0.0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- 5. TRANSACTION DATE ---
              ListTile(
                title: const Text('Transaction Date'),
                subtitle: Text("${_selectedDate.toLocal()}".split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),

              // --- 6. NOTES ---
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                ),
                maxLength: 100, // Strictly enforces the 100 character limit
              ),
              const SizedBox(height: 24),

              // --- 7. SUBMIT BUTTON ---
              ElevatedButton(
                onPressed: _submitForm,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Save Transaction',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
