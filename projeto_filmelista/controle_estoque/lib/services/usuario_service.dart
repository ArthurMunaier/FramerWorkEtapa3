import '../models/usuario.dart';
import 'database_service.dart';

class UsuarioService {
  Future<bool> emailExiste(String email) async {
    final db = await DatabaseService.banco;
    final r = await db.query('usuarios', where: 'email = ?', whereArgs: [email]);
    print('SELECT → Verificando e-mail: $email');
    return r.isNotEmpty;
  }

  Future<bool> cadastrar(Usuario usuario) async {
    if (await emailExiste(usuario.email)) return false;
    final db = await DatabaseService.banco;
    await db.insert('usuarios', usuario.toMap());
    print('INSERT → Usuário cadastrado: ${usuario.nome}');
    return true;
  }

  Future<Usuario?> login(String email, String senha) async {
    final db = await DatabaseService.banco;
    print('SELECT → Procurando usuário: $email');
    final r = await db.query('usuarios', where: 'email = ? AND senha = ?', whereArgs: [email, senha], limit: 1);
    if (r.isEmpty) {
      print('SELECT → Usuário não encontrado');
      return null;
    }
    final usuario = Usuario.fromMap(r.first);
    print('SELECT → Usuário encontrado: ${usuario.nome}');
    return usuario;
  }
}
