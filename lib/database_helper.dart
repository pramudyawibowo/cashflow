import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lsp/models/user.dart';
import 'package:lsp/models/transaction.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT)');
    await db.execute(
        'CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, amount INTEGER, description TEXT, status INTEGER, date DATE, FOREIGN KEY(user_id) REFERENCES users(id))');
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> queryUser(String username) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result =
        await db.query('users', where: 'username = ?', whereArgs: [username]);
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<int> insertTransaction(Transactions transaction) async {
    Database db = await instance.database;
    return await db.insert('transactions', transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Transactions>> queryAllTransaction(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db
        .query('transactions', where: 'user_id = ?', whereArgs: [userId]);
    return result.isNotEmpty
        ? result.map((item) => Transactions.fromMap(item)).toList()
        : [];
  }

  Future<List<Transactions>> queryAllIncomeTransaction(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM transactions WHERE status = 0 AND user_id = $userId');
    return result.isNotEmpty
        ? result.map((item) => Transactions.fromMap(item)).toList()
        : [];
  }

  Future<List<Transactions>> queryAllOutcomeTransaction(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM transactions WHERE status = 1 AND user_id = $userId');
    return result.isNotEmpty
        ? result.map((item) => Transactions.fromMap(item)).toList()
        : [];
  }

  Future<int> queryTotalIncome(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT SUM(amount) FROM transactions WHERE status = 0 AND user_id = $userId');
    return result.first.values.first ?? 0;
  }

  Future<int> queryTotalOutcome(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT SUM(amount) FROM transactions WHERE status = 1 AND user_id = $userId');
    return result.first.values.first ?? 0;
  }

  Future<int> queryUpdatePassword(int userId, String password) async {
    Database db = await instance.database;
    return await db.rawUpdate(
        'UPDATE users SET password = ? WHERE id = ?', [password, userId]);
  }
}
