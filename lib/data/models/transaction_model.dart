class TransactionModel {
  final int? id;
  final String symbol;
  final String transactionType;
  final int quantity;
  final double purchasePrice;
  final String transactionDate;
  final String? notes;

  const TransactionModel({
    this.id,
    required this.symbol,
    required this.transactionType,
    required this.quantity,
    required this.purchasePrice,
    required this.transactionDate,
    this.notes,
  });

  factory TransactionModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return TransactionModel(
      id: map['id'] as int?,
      symbol: map['symbol'] as String,
      transactionType: map['transaction_type'] as String,
      quantity: map['quantity'] as int,
      purchasePrice: (map['purchase_price'] as num).toDouble(),
      transactionDate: map['transaction_date'] as String,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'symbol': symbol,
      'transaction_type': transactionType,
      'quantity': quantity,
      'purchase_price': purchasePrice,
      'transaction_date': transactionDate,
      'notes': notes,
    };
  }
}