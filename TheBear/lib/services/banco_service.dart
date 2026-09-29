import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/usuario.dart';
import '../models/pedido.dart';

class BancoService {
  Future<Database> getBanco() async {
    String caminho = join(await getDatabasesPath(), 'the_bear.db');

    return openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            senha TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE pedidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cliente TEXT,
            prato TEXT,
            quantidade INTEGER,
            valorUnitario REAL,
            total REAL,
            status TEXT
          )
        ''');
      },
    );
  }

  Future<void> inserirUsuario(Usuario usuario) async {
    final db = await getBanco();
    await db.insert('usuarios', usuario.toMap());
  }

  Future<bool> verificarLogin(String email, String senha) async {
    final db = await getBanco();

    final resultado = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    return resultado.isNotEmpty;
  }

  Future<void> inserirPedido(Pedido pedido) async {
    final db = await getBanco();
    await db.insert('pedidos', pedido.toMap());
  }

  Future<List<Pedido>> buscarPedidos() async {
    final db = await getBanco();
    final resultado = await db.query('pedidos');

    return resultado.map((map) {
      return Pedido.fromMap(map);
    }).toList();
  }

  Future<void> finalizarPedido(int id) async {
    final db = await getBanco();

    await db.update(
      'pedidos',
      {'status': 'Finalizado'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> excluirPedido(int id) async {
    final db = await getBanco();

    await db.delete(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
