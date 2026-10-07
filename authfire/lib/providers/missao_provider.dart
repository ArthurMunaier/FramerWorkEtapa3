import 'package:flutter/material.dart';

import '../models/missao.dart';
import '../services/missao_service.dart';

class MissaoProvider extends ChangeNotifier {
  final MissaoService _service = MissaoService();

  List<Missao> missoes = [];

  bool carregando = true;

  MissaoProvider() {
    carregarMissoes();
  }

  void carregarMissoes() {
    _service.listarMissoes().listen((lista) {
      missoes = lista;

      carregando = false;

      notifyListeners();
    });
  }

  Future<void> adicionar(String titulo, int grau) async {
    if (titulo.trim().isEmpty) {
      return;
    }

    await _service.adicionarMissao(titulo.trim(), grau);
  }

  Future<void> alterarStatus(Missao missao) async {
    await _service.alterarStatus(missao);
  }

  Future<void> excluir(String id) async {
    await _service.excluirMissao(id);
  }
}
