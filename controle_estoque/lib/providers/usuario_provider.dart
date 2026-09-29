import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService service = UsuarioService();
  Usuario? usuarioLogado;
  bool carregando = false;

  Future<String?> cadastrar(String nome, String email, String senha) async {
    if (nome.trim().isEmpty || email.trim().isEmpty || senha.trim().isEmpty) return 'Preencha todos os campos.';
    final ok = await service.cadastrar(Usuario(nome: nome.trim(), email: email.trim(), senha: senha));
    return ok ? null : 'E-mail já cadastrado.';
  }

  Future<bool> login(String email, String senha) async {
    carregando = true; notifyListeners();
    usuarioLogado = await service.login(email.trim(), senha);
    carregando = false; notifyListeners();
    return usuarioLogado != null;
  }

  void sair() { usuarioLogado = null; notifyListeners(); }
}
