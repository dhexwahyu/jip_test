import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('coupon_data.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE operators (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        location TEXT,
        created_at TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE batches (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        batch_number INTEGER,
        operator_id INTEGER,
        location TEXT,
        notes TEXT,
        started_at TEXT,
        finished_at TEXT,
        FOREIGN KEY (operator_id) REFERENCES operators(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE boxes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        box_number INTEGER,
        batch_id INTEGER,
        total_coupons INTEGER,
        FOREIGN KEY (batch_id) REFERENCES batches(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE prizes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT,
        amount INTEGER,
        quantity INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE coupons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serial_number TEXT,
        box_id INTEGER,
        prize_id INTEGER,
        FOREIGN KEY (box_id) REFERENCES boxes(id),
        FOREIGN KEY (prize_id) REFERENCES prizes(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE production_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        batch_id INTEGER,
        operator_id INTEGER,
        timestamp TEXT,
        FOREIGN KEY (batch_id) REFERENCES batches(id),
        FOREIGN KEY (operator_id) REFERENCES operators(id)
      );
    ''');

    await _seedPrizeData(db);
  }

  Future<void> _seedPrizeData(Database db) async {
    final prizeData = [
      {'description': 'Rp 100.000', 'amount': 100000, 'quantity': 50},
      {'description': 'Rp 50.000', 'amount': 50000, 'quantity': 100},
      {'description': 'Rp 20.000', 'amount': 20000, 'quantity': 250},
      {'description': 'Rp 10.000', 'amount': 10000, 'quantity': 500},
      {'description': 'Rp 5.000', 'amount': 5000, 'quantity': 1000},
      {'description': 'Anda Belum Beruntung', 'amount': 0, 'quantity': 8100},
    ];
    for (var prize in prizeData) {
      await db.insert('prizes', prize);
    }
  }

}
