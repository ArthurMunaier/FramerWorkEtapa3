import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get banco async {
    if (_db != null) return _db!;
    databaseFactory = databaseFactoryFfiWeb;
    _db = await openDatabase('controle_estoque.db', version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, email TEXT NOT NULL UNIQUE, senha TEXT NOT NULL)');
      await db.execute('CREATE TABLE produtos (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, categoria TEXT NOT NULL, quantidade INTEGER NOT NULL, preco REAL NOT NULL)');
    });
    return _db!;
  }
}
