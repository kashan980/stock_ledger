import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // 1. The Singleton Pattern
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // 2. The Database Connection Getter
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('portfolio_ledger.db');
    return _database!;
  }

  // 3. Database Initialization
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // 4. Schema Creation (Raw SQL)
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        symbol TEXT NOT NULL,
        transaction_type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        purchase_price REAL NOT NULL,
        transaction_date TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }

  // ==========================================
  // 5. CRUD OPERATIONS (Create, Read, Update, Delete)
  // ==========================================

  // CREATE: Insert a new transaction into the table
  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('transactions', row);
  }

  // READ: Fetch all transactions, sorted newest to oldest
  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final db = await instance.database;
    // Ordering by 'id DESC' ensures the newest entries appear at the top of the list
    return await db.query('transactions', orderBy: 'id DESC');
  }

  // UPDATE: Edit an existing transaction
  Future<int> updateTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update(
      'transactions',
      row,
      where: 'id = ?',
      whereArgs: [id], // Prevents SQL Injection attacks
    );
  }

  // DELETE: Remove a transaction from the ledger
  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
