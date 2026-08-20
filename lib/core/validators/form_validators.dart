class FormValidators {
  // Stock ticker
  static String? stockSymbol(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Stock ticker is required';
    }

    if (!RegExp(
      r'^[A-Z]{3,6}$',
    ).hasMatch(value.trim())) {
      return 'Enter 3-6 uppercase letters';
    }

    return null;
  }

  // Transaction type
  static String? transactionType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select transaction type';
    }

    if (value != 'BUY' && value != 'SELL') {
      return 'Invalid transaction type';
    }

    return null;
  }

  // Quantity
  static String? quantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }

    if (!RegExp(
      r'^[1-9][0-9]*$',
    ).hasMatch(value.trim())) {
      return 'Enter a positive whole number';
    }

    final number = int.tryParse(value.trim());

    if (number == null || number <= 0) {
      return 'Quantity must be greater than 0';
    }

    return null;
  }

  // Price
  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }

    final pricePattern = RegExp(
      r'^\d+(\.\d{1,2})?$',
    );

    if (!pricePattern.hasMatch(value.trim())) {
      return 'Enter a valid price with up to 2 decimals';
    }

    final number = double.tryParse(value.trim());

    if (number == null || number <= 0) {
      return 'Price must be greater than 0';
    }

    return null;
  }

  // Notes
  static String? notes(String? value) {
    if (value != null && value.length > 100) {
      return 'Notes cannot exceed 100 characters';
    }

    return null;
  }
}