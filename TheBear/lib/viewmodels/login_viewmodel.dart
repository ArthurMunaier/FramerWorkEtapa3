import 'package:flutter/material.dart';
import '../services/banco_service.dart';
import '../models/usuario.dart';

class LoginViewModel extends ChangeNotifier {
  final BancoService banco = BancoService();

  bool carregando = false;
  String mensagem = '';

  Future<bool> login(String email, String senha) async {
    carregando = true;
    mensagem = '';
    notifyListeners();

    bool valido = await banco.verificarLogin(email, senha);

    carregando = false;

    if (!valido) {
      mensagem = 'E-mail ou senha inválidos';
    }

    notifyListeners();

    return valido;
  }

  Future<void> cadastrar(
    String nome,
    String email,
    String senha,
  ) async {
    Usuario usuario = Usuario(
      nome: nome,
      email: email,
      senha: senha,
    );

    await banco.inserirUsuario(usuario);
  }
}
